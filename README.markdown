# FG EFB

(a.k.a. GearPad)

## Introduction

The FG EFB simulates, within the constraints of what is possible in FlightGear,
a consumer-grade tablet running Electronic Flight Bag (EFB) software to replace
paper documents in the cockpit.
This repository is intended for aircraft developers who wish to incorporate a
GearPad in their aircraft; it is not designed as an add-on.

## Installation

### Downloading

- Clone the repository:
  ```bash
  git clone --recursive git@github.com:tdammers/fg-efb
  ```
  If you have already cloned the repository, but without `--recursive`, you can
  also do this instead:
  ```bash
  cd fg-efb
  git submodule update --init
  ```
- Run the build script:
  ```bash
  cd fg-efb
  ./build.sh
  ```

Alternatively, you can manually download the `fg-canvas-html` repo from
https://github.com/tdammers/fg-canvas-html/, and copy the `Nasal/html`
directory into the EFB project.

### Installing into your aircraft

- Merge the included `Nasal`, `Systems`, and `Models` trees into your aircraft.
  You can use the provided `install.sh` script to do this, at least on a
  Unix-like platform.
- Edit your aircraft XML to include the following:
  - In `/instrumentation`:
    ```xml
        <efb>
            <available type="bool">true</available>
            <power type="bool">true</power>
            <brightness type="double">1.0</brightness>
            <orientation-norm type="double">0</orientation-norm>
            <selected-orientation-norm type="double">0</selected-orientation-norm>
            <flightbag-companion-uri type="string">http://localhost:7675/</flightbag-companion-uri>
            <allow-keyboard-grabbing type="bool">false</allow-keyboard-grabbing>
            <keyboard-grabbed type="int">0</keyboard-grabbed>
        </efb>
    ```
  - In `/nasal`:
    ```xml
        <efb>
            <file>Aircraft/{your aircraft directory}/Nasal/efb.nas</file>
        </efb>
    ```
  - In `/sim/systems`:
    ```xml
      <property-rule n="103">
          <path>Aircraft/{your aircraft directory}/Systems/EFB.xml</path>
      </property-rule>
    ```
  - In `/sim/aircraft-data`: 
    ```xml
      <path>/instrumentation/efb/available</path>
      <path>/instrumentation/efb/brightness</path>
      <path>/instrumentation/efb/flightbag-companion-uri</path>
      <path>/instrumentation/efb/allow-keyboard-grabbing</path>
    ```
- Edit your model XML to place the `Models/EFB/EFB.xml` model in a suitable
  location.
  Something like this should work:
  ```xml
    <model>
        <path>Aircraft/{your aircraft directory}/Models/EFB/EFB.xml</path>
        <name>EFB1</name>
        <offsets>
            <x-m>-12.3</x-m>
            <y-m>-0.9</y-m>
            <z-m>1.1</z-m>
            <pitch-deg>-30</pitch-deg>
            <heading-deg>30</heading-deg>
        </offsets>
    </model>
  ```
  Adjust the position, pitch, and heading, as needed.
  You can place multiple EFB's, but they will all display the same screen and
  interact with the same simulated tablet device.
- Facilitate configuration of the EFB by binding the following properties to
  GUI widgets in your aircraft configuration dialog:
  - `/instrumentation/efb/available` (this determines whether the EFB is
    visible and usable in the cockpit)
  - `/instrumentation/efb/flightbag-companion-uri` (this points to the URI
    where the companion app can be reached; `localhost:7675` is the default for
    [fg-efb-server](https://github.com/fg-efb-server).
  - `/instrumentation/efb/allow-keyboard-grabbing` (boolean; if set, allows
    the EFB to grab physical keyboard inputs whenever an on-screen keyboard is
    displayed on the EFB).
