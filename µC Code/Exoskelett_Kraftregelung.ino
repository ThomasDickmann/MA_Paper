#include <SD.h>
#include <math.h> 

//Vorbereitung SD Karte /////////////////////////////////////////////
File dataFile; //Fileobjekt für SD Karte erzeugen

//Aufruf in Setup, Karteninitialisierung
void initCard()
{
  bool ret;
  Serial.print("Initialisiere SD Karte...");
  ret = SD.begin(BUILTIN_SDCARD);
  if (!ret) {
    Serial.println("Card failed, or not present");
    while (1) {
    }
  }
  Serial.println("Karte initialisiert.");
  }

//Aufruf in Setup, Vorbereitung des dataFile zum beschreiben
bool openFile_write(const char *filename)
{
  dataFile = SD.open(filename, FILE_WRITE);  
  dataFile.flush();
  return (dataFile==true);
}
///////////////////////////////////////////////////////////////////////

//Laufzeit und Loggingfrequenz einstellen ////////////////////////////
//Setzen von fester Loopedauer über Timer im Hintergrund, sodass der Controller parallel arbeiten kann
unsigned int loopTime = 100; //Wert für gewünschtes Loopintervall in Millisekunden
unsigned long breakTime; //Zeitstempel zu Anfang des Loops -> Ablegen des Zeitpunkts für Loopende

//Counter für gewünschte Anzahl an Loopdurchläufen 
int totalRuns = 60000/loopTime; //(60 Sekunden pro Bewegung)
int t = 0; //Zählervariable für Loopdurchläufe
int k = 0; //Zählervariable für Funktion Aktortrajektorie
///////////////////////////////////////////////////////////////////////

//Verzögerung für Kraftsensormessungen 

int t_del = 3000;

//Parametrierung der Aktorik///////////////////////////////////////////
const float l_akt = 139.3f; //102mm Aktorlänge von Loch zu Loch + Kraftsensorlänge von 37.3mm 
const float d_b = 161.062f; //Abstand Glelenk B zu Mountgelenk Aktorrückseite
const float akt_x = -160.761f; //Abstand in X-Richtung Welt KS Gelenk B zu Mountgelenk Aktorrückseite in mm 
const float akt_y = -9.845f; //Abstand Y-Richtung Gelenk B zu Mountgelenk Aktorrückseite in mm 
const float alpha_const = 0.0612f; //Winkel zwischen d_B und X-Achse Weltsysten in rad (3.5°)
const float theta = 0.6109f; //Winkel zwischen l_1 und l_2 in rad (35°)
const float l_s = 20.0f; //Kurzer Arm der Antriebsschwinge
//const float phi_B_min = 0.3491f; //20°, Minimalwert des Schwingenwinkels -> Berechnung max. Aktorstellung
const float phi_B_max = 2.2340f; //128°, Maximalwert des Schwingenwinkels -> Berechnung min. Aktorstellung 
//Überschreiben für Demo: Weniger Auslenkung
const float phi_B_min = 0.9235f; //30°
const float delta_phi_max = 108.000f; //Maximales Intervall der Antriebsschwinge in Grad
const float val_count_phi_B_max = 5.0f; //Startwert für Loopcounter, sodass Aktor aus seiner Minimalposition heraus startet (Anfahren in Setup-Funktion!)
const float pi = 3.1416f; //Konstante für Wert von pi erzeugen 
const float multip = (2*pi)/totalRuns; //Aufteilung von 2pi auf die gesamte Anzahl an Durchläufen
///////////////////////////////////////////////////////////////////////


//Funktionen zur Berechnung der Aktorvariablen/////////////////////////
//Berechnungen von Sollstellung s des Aktors aus Schwingenwinkelvorgabe [Verifiziert durch Vergleich mit MATLAB]
float getActuationSignal (float phi){
    float alpha = pi - theta - phi + alpha_const;
    //Serial.print("alpha= ");
    //Serial.println(alpha);
    float l = sqrtf((powf(l_s,2) + powf(d_b,2) - 2*l_s*d_b*cosf(alpha))); //Kosinussatz zur Berechnung der Gesamtlänge des Aktorverbands l
    //Serial.print("l= ");
    //Serial.println(l);
    float s_nom = l - l_akt;
    return s_nom; 
}

//Berechnung des aktuell anliegenden Antriebsmoments aus Schwingenwinkel und gemessener Aktorkraft [Verifiziert durch Vergleich mit MATLAB]
float getActuationTorque (float phi_B, float F_Aktor){
    float alpha_quer = pi - theta - phi_B;  //Winkel zwischen X-Achse und l_s
    //Serial.print("alpha_quer= ");
    //Serial.println(alpha_quer);
    float S_x = -l_s * cosf(alpha_quer); //x-Position der Spitze des kurzen Schwingenarms 
    float S_y = l_s * sinf(alpha_quer); //y-Position der Spitze des kurzen Schwingenarms 
    float phi_F = getAngle(akt_x,akt_y,S_x,S_y); // Funktion: Berechnet aktuellen Kraftvektorwinkel im Raum 
    //Serial.print("phi_F= ");
    //Serial.println(phi_F);
    float F_Akt_x = F_Aktor * cosf(phi_F); //Komponenten des Kraftvektors in Weltsystem
    float F_Akt_y = F_Aktor * sinf(phi_F);
    float M_akt = (F_Akt_x * S_y + F_Akt_y * (-S_x));  //[Nmm], Berechnen des Moments um Punkt B, pos. Richtung s. Skizze, pos. delta_x führt zu neg. Moment nach Skizze  
    return fabs(M_akt);
}

//Benötigte Funktion zur Berechnung des Kraftvektorwinkels [Verifiziert durch Vergleich mit MATLAB]
float getAngle(float p1_x, float p1_y, float p2_x, float p2_y){
    float delta_x = p2_x - p1_x; //akt_x und akt_y konst. Größen definiert in aktorik.h
    float delta_y = p2_y - p1_y;  
    float phi = 0;     
    if (delta_x > 0){
       phi = atanf(delta_y/delta_x);}
    else if (delta_x < 0){
       phi = atanf(delta_y/delta_x) - pi;}
    else if (delta_x == 0 && delta_y > 0){
       phi = pi/2; } 
    else if (delta_x == 0 && delta_y < 0){
       phi = -pi/2; }
    return phi;
}
///////////////////////////////////////////////////////////////////////

// Funktionen zur Aktorsteuerung //////////////////////////////////////

//Signalpin PWM-Output für Aktor (Kopie von oben)
const int aktorpin = 29;
 
//Berechnung der nominellen Position des Aktors, aus nominellem Schwingenwinkel phi_B, aus Timer/Counter t (Zahl Loopdurchläufe) [Verifiziert mit MATLAB]
float getNomPosition (int k){
    //Berechnung des nominellen Schwingenwinkels aus Loopcounter
    float sinsig = k * multip; //Winkelstellung des Sinussignals basierend auf Loopdurchlaufnummer berechnen (Intervall 0-2*pi auf 10s)
    //Serial.print("sinsig= ");
    //Serial.println(sinsig);
    float phi_raw = sinf(sinsig + 0.5*pi); //Sinusschwingung 0.1Hz mit Amplitude [-1,1], Phasenverschiebung um pi/2, sodass bei counter = 0 (Bewegungsbeginn) mit Maximalwert gestartet wird
    //Serial.print("phi_raw= ");
    //Serial.println(phi_raw);
    float phi_d = (phi_raw * delta_phi_max/2); //Skalierungsfakor ist halbes maximales Winkelintervall
    //Serial.print("phi_d ");
    //Serial.println(phi_d);
    phi_d = phi_d + delta_phi_max/2 + (phi_B_min/pi) * 180; // Offsetfaktor positioniert das Intervall richtig in y-Richtung, sodass phi_B_max erreicht wird (Angegeben in Grad)
    //Serial.print("phi_d ");
    //Serial.println(phi_d);
    float phi_r = (phi_d / 180) * pi; //Konvertierung des nominellen Schwingenwinkels von Deg nach Rad
    //Serial.print("phi_r ");
    //Serial.println(phi_r);
    //Berechnung der korrespondierenden Schubstangenposition
    float nomPosition = getActuationSignal (phi_r); 
    return nomPosition;
} 

//Funktion zum Mappen von Kommazahlen [Tested]
float mapf(float x, float in_min, float in_max, float out_min, float out_max){ 
    float val_mapped = (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
    return val_mapped;
}

//Mappen des Ausgangssignals auf max. Range des Aktors (0-3.3V PWM = 0-33mm Aktorzustellung) [Tested]
float mapActuatorInput(float nomPosition){
  //Max. Range Aktor 0-33mm, max. Range Input = 0-34.01mm
  float nomPositionMapped = mapf(nomPosition, 0, 34.01, 0, 33);
  return nomPositionMapped;
}


//Ansteuern des Aktors basierend auf in Loop vorgegebenem Sollwert für s
void positionActuator(int k){
  //Bestimmen der nominellen Aktorposition basieren auf Loopdurchlauf
  float nomPos = getNomPosition(k);
  //Mappen der nominellen Position auf Range des Aktors 
   float nomPosMapped = mapActuatorInput(nomPos);
  //Schreiben der Position als PWM Signal am Aktorpin //Begrenzte Auflösung AnalogWrite!
  int nomPosInt = nomPosMapped*1000;
  int outputsignal = map(nomPosInt, 0, 33000, 0, 256); //Range analogWrite von 0-256, Umrechnen der Kommawerte in der Position auf int Werte 
  //Serial.print("Outputsignal ");
  //Serial.println(outputsignal); 
  analogWrite(aktorpin, outputsignal); 
}

///////////////////////////////////////////////////////////////////////


//Funktionen zur Verarbeitung des eingelesenen Positionssensors an Gelenk B/////////////
//Positionssensoren: 
unsigned int readAngleRadB (int potipin){
  unsigned int rawData = analogRead(potipin); 
  unsigned int DataMapped = rawData; //TODO: Verarbeitung der Kalibrierungskurven
  //Geradengleichung benutzen, um kalibrierte Winkelstellung aus ADC Wert zu berechnen
  return DataMapped;  
}

//Wegen verschiedenen Kalibriergrade werden eigene Funktionen für jeden Sensor gebraucht! 
///////////////////////////////////////////////////////////////////////


//Funktionen zur Verstellung der Aktors////////////////////////////////
//Bestimmen des Stellsignals
//float getNomPosition (float nomPhi) {
//  return PosNom; 
//}

//Manuelle Verstellung des Aktors über Drehpoti
void posManual (int inputpin, int aktorpin){
  int intputsignal = analogRead(inputpin);
  int outputsignal = map(intputsignal, 0, 1023, 0, 333); 
  Serial.println(outputsignal); 
  analogWrite(aktorpin, outputsignal); 
}

//////////////////////////////////////////////////////////////////////


//Zuweisen der MCU Pins ///////////////////////////////////////////////
const int inputpin = A10; 

//Positionssensorik
const int potiA = A13; 
const int potiB = A12; 
const int potiK = A11;

//Kraftsensorik 
const int fSenB = A17; //Pin41
const int fSenA = A16; //Pin40

//Signalpin PWM-Output für Aktor (Kopie von oben)
//const int aktorpin = 29; 
////////////////////////////////////////////////////////////////////////

unsigned long setupTime;

//Kraftregelung
int sensorpin = A17;
int dir = 1; //Flag für Richtung R=1 vorwärts, R=0 rückwärts
int per = 1; //Flag für aktuelle Periode 1:(0,pi) oder Periode 2:(pi,2pi)
int valSens; //Analog eingelesenen Sensorwert, soll Kraftwert simulieren 

float M_upper = 0.07 ; //Oberer Grenzwert für Moment [Nm] -> Umkehrung von Vorwärts nach Rückwärts
float M_lower = 0.01; //Unterer Grenzwert für Moment -> Umkehrung von Rückwärts nach Vorwärts


void setup() {
  
  analogWriteFrequency(aktorpin, 1000); // PWM Frequenz des Aktorpins auf 1 kHz festlegen

   //Anfahren der Ausgangsposition des Aktors (Maximale Extension des Finger)  
  positionActuator(0);
  
  Serial.begin(9600); //Starten Serial Monitor
  while(!Serial); //Warten, bis Serial Monitor geöffnet
  delay(2000); 
  
  pinMode(aktorpin, OUTPUT); 

  //Einstellungen für den ADC: Auflösung und Glättung der Messwerte
  analogReadResolution(12);
  analogReadAveraging(32); //8, 16, 32

  //Vorbereiten der SD Karte für Schreiben (Funktionen von Frank) 
  initCard();
  openFile_write("log_1.txt");

  //Anfahren der Ausgangsposition des Aktors (Maximale Extension des Finger)  
  positionActuator(0);

  setupTime = millis();
}




  
  void loop() {

  //Positionieren des Aktors nach Loopdurchlaufsnummer 
  positionActuator(k);
  
  //Zeitstempel: Aktueller Loopdurchlauf (Startet bei 0)
  unsigned long ms = millis() - setupTime; 

 
  //Pausen für Kraftsensortest einbauen (Beladezeiten)
   if (t == 50){
      //Begin Beladen nach 5s
     // Serial.println(" Pause Beladen  "); 
     delay(t_del); 
     }
   else if (t == 150){
    //Serial.print(" Pause Beladen "); 
    delay(t_del);
    }
   else if (t == 250){
    delay(t_del);
    //Serial.print(" Pause Beladen "); 
    } 
   else if (t == 350){
    delay(t_del);
   //Serial.print(" Pause Beladen "); 
    }
   else if (t == 450){
    delay(t_del);
    //Serial.print(" Pause Beladen "); 
    }
   else if (t == 550){
    delay(t_del);
    //Serial.print(" Pause Beladen "); 
    }
   else if (t == 650){
    delay(t_del);
    //Serial.print(" Pause Beladen "); 
    }
  else{
  }

  if(t >=50 && t< 150){
    ms=ms-t_del;
  }
  else if (t >=150 && t< 250){
    ms=ms-(2*t_del);
  }
  else if (t >=250 && t< 350){
    ms=ms-(3*t_del);
  }
  else if (t >=350 && t< 450){
    ms=ms-(4*t_del);
  }
  else if (t >=450 && t< 550){
    ms=ms-(5*t_del);
  }
  else if (t >=550 && t< 650){
    ms=ms-(6*t_del);
  }
  else{
    //do nothing
  }

  Serial.print(" "); 
  Serial.print(t);
  Serial.print(" "); 
  Serial.print(ms);
  
  //Wert für Endzeitpunkt von aktuellem Loop erzeugen
  breakTime = millis() + loopTime; 
  //Serial.print("Loop startet: ");

  //Einlesen der Positionssensorik (Potentiometer)
  unsigned int angleA = analogRead(potiA);
  unsigned int angleB = analogRead(potiB);
  //Ueberschreiben mit fixem ADC Wert für Demo 
  //angleB = 2600;
  unsigned int angleK = analogRead(potiK);
  
  /*
  //Mappen der Sensordaten auf Winkelwerte:
  //TODO
  Serial.print("Winkel B: ");
  Serial.print(angleB); 
  Serial.print("   Winkel A: ");
  Serial.print(angleA); 
  Serial.print("   Winkel K: ");
  Serial.println(angleK);
  */

  //Einlesen der Kraftsensorik (A201s)
  unsigned int forceB = analogRead(fSenB); //Sensor oben, Anschluss an GND Seite
  unsigned int forceA = analogRead(fSenA);  //Sensor unten, Anschluss an VCC Seite

  //Mappen der Sensordaten auf Winkelwerte:
  //TODO
  Serial.print("   Kraft Sensor B (vorne, Druck): ");
  Serial.print(forceB); 
  Serial.print("   Kraft Sensor A (hinten, Zug): ");
  Serial.println(forceA); 
  
  
  //Serial.print("Loop Nummer ");
  //Serial.println(t);
  
  //Bestimmen des momentanen Schwingenwinkels
  float   phi_B_d = 0.0788*angleB - 114.2788; //Umrechnung des ADC Werts über lineare Regression von für Positionssensorik an Gelenk B
  float   phi_B = phi_B_d*(pi/180); //Umrechnung des Winkels in Radiant 
  //Serial.print("Winkel B berechnet = ");
  //Serial.println(phi_B_d);
 /* float   phi_A_d = 0.0843*angleA - 206.2727; //Umrechnung des ADC Werts über lineare Regression von für Positionssensorik an Gelenk A
  float   phi_A = phi_A_d*(pi/180); //Umrechnung des Winkels in Radiant 
  //Serial.print("Winkel A berechnet = ");
  //Serial.println(phi_A_d);
  float   phi_K_d = 0.0721*angleK - 88.8166; //Umrechnung des ADC Werts über lineare Regression von für Positionssensorik an Gelenk K
  float   phi_K = phi_K_d*(pi/180); //Umrechnung des Winkels in Radiant 
  //Serial.print("Winkel K berechnet = ");
  //Serial.println(phi_K_d);
*/
  //Bestimmen der Kräfte
  float F_back = 0.0036 *forceA - 2.0806;  //Kraftsensor A 
  float F_front =0.0033 * forceB - 2.2402; //Kraftsensor B
  
  //Berechnen des Antriebsmoments aus Aktorkraft
  float F_akt = F_front - F_back; //Differenz der Kraftsensoren ist aktuelle Aktorkraft auf Kinematik
  float M_akt = getActuationTorque(phi_B,F_akt)/1000; //Nm aus Nmm 
  //Ueberschreiben mit fixem Wert fuer Demo an Hand (keine Positionssensorik verbaut)

  /*
  //float M_akt = 10; //Regler umgehen, immer Vorwärts
  Serial.print("M_akt = ");
  Serial.println(M_akt);
  */
  
  //DEMO KRAFTREGELUNG: Dummywert nutzen (Encoder)
  //M_akt = analogRead(sensorpin); //Kraftwert einlesen 
  //Serial.print("Sensorwert F= ");
  //Serial.println(valSens);

  //Zweipunktregler für Kraftregelung
  //Flagprüfung: Betriebsmodus feststellen 
  switch (dir) {
  case 1: //Richtung = Vorwärts, Oberer Grenzwert relevant
    //Prüfung Kraftgrenzwert
    if (M_akt < M_upper){
      //Grenzwert nicht erreicht, im Modus Vorwärts bleiben
      //Begrenzung auf maximalen Wert totalRuns
     k++; //Variable für Schwingenwinkel um 1 erhöhen
     }
     else {
      //Grenzwert überschritten, umkehren der Bewegungsrichtung in Rückwärts
      dir=0; //Umschalten der Flagvariable für Richtung
      Serial.println("oberer Grenzwert überschritten, Wechsel in Rückwärtsbewegung");
    }
    break;
  case 0: //Richtung = Rückwärts, unterer Grenzwert relevant
    //Prüfung Kraftgrenzwert
    if (M_akt > M_lower){
      //Grenzwert immer noch zu hoch, im Modus rückwärts bleiben 

      //WICHTIG: Periodizität beachten!
      //In erster Periode darf nach einer Bewegungsumkehrung nicht unter 0 gefahren werden
      //In zweiter Periode darf nach Bewegungsumkehrung nicht unter pi gefahren werden 
      //Andernfalls wird der kritische Winkel nach Umkehr der Bewegung wegen Periodizität erzeut durchschritten!

        switch(per){
        case 1: //Periode 1
           if (k > 0){
              k--; 
           }
           else { 
                //nicht weiter reduzieren (Periodizität)
           }
        break; 
        case 2: //Periode 2
            if (k > totalRuns/2){
                 k--; 
            }
            else { 
            //nicht weiter reduzieren (Periodizität)
            }
        break;
        }//Ende der Fallunterscheidung Periode
    }//Ende Fall Grenzwert zu hoch
    
    else {
      //Kraftwert ausreichen abgefallen, umkehren der Bewegungsrichtung in Vorwärts
      dir=1; //Umschalten der Flagvariable für Richtung
      Serial.println("unterer Grenzwert unterschritten, wechsel in Vorwärtsbewegung");
    }
    break; //Ende Case Rückwärts
  }//Ende Zweipunktregelung

  //Serial.print("k= ");
  //Serial.println(k);

  if (k<totalRuns/2){
    //Serial.print("Periode = ");
    per = 1;
    //Serial.println(per);
  }
  if (k>totalRuns/2){
    //Serial.print("Periode = 2");
    per = 2;
    //Serial.println(per);
  }
  
  //Schreiben der erhobenen Daten auf die SD Karte als 32Byte String
  dataFile.printf("%5u;%4u;%4u;%4u;%4u;%4u\r\n", ms, angleB, angleA, angleK, forceA, forceB);
  
   //Prüfen der Abbruchbedingung: Beenden der Messungen nach Anzahl totalRuns Loopdurchläufen
  if (t++ > totalRuns) {
    dataFile.close();
    Serial.println("Messungen abgeschlossen, Programm beendet");
    while(1);
  } //Durchgang

  //Prüfen, ob gesetzte Soll-Loopzeit verstrichen ist - wenn nicht, warten bis neuer Loop beginnen kann 
  while(millis() < breakTime){
      //waiting for loop time to finish - do nothing
   } //Loopdauer
  
} //Loop Funktion
