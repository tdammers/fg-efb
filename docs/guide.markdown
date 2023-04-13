# `fg-efb`, a.k.a. GearPad

## Introduction

The FlightGear EFB (called "GearPad" in-sim) is a simulation of a fictional
consumer-grade device configured as an Electronic Flight Bag (EFB). It provides
an extensible platform for all sorts of applications, shipping with a few
aircraft-independent apps, and providing an extension mechanism by which
aircraft developers can add their own apps.

## Installation

Unfortunately, the EFB needs to be integrated with each aircraft type
individually; it is not possible (at least not currently) to install it as an
add-on. If you are an aircraft developer interested in adding the EFB to your
aircraft, see the section "Installing Into Your Aircraft" in the included
[README](https://github.com/tdammers/fg-efb#readme).

## General Usage

![The EFB **Home Screen**,<br/>as configured in the E-Jet family<br/>(apps may differ)](img/home-screen.jpg)

The EFB starts up showing the home screen, from where you can launch any of the
applications.

It works mostly like a typical real-world tablet device, however, due to the
hardware and software limitations of the FlightGear platform, interactions and
UI had to be redesigned a little.

Simulated inputs work as follows:

- Clicking on the screen with the primary mouse button (usually the left)
  simulates tapping the screen.
- Using the scroll wheel while hovering over the screen simulates either "pinch
  zoom" or "vertical swipe"; the behavior is defined per application (e.g., in
  the Maps app, the scroll wheel controls zoom, whereas in the Kneepad app, it
  scrolls through the text).
- Clicking the frame with the primary mouse button rotates the device. Some
  apps will detect this and reconfigure themselves for landscape mode, but not
  all of them support this.
- Using the scroll wheel while hovering over the case (not the screen) adjusts
  screen brightness.
- Middle-click on either the case or the screen reloads the EFB code and
  resets the device (this is primarily a debugging feature and will be removed
  or disabled by default in the future).
- If 'keyboard grabbing' is enabled in the settings, whenever an on-screen
  keyboard is active, the EFB will capture most physical keyboard inputs and
  redirect them to the on-screen keyboard.

### UI Elements of the Home Screen

![UI Elements of the Home Screen](img/home-screen-annotated.jpg)

#### Status Bar

The status bar reflects device status, like in a real mobile device. Possible
indicators include:

- The **Clock**, showing the current in-sim local time
- A **Battery** indicator; battery charge is not currently simulated, so the
  battery indicator always shows "100%".
- A **Connection Strength** indicator; connection strength is not currently
  simulated, so it always shows a perfect signal.
- A **Keyboard Grab** indicator (shaped like a key), which appears when the
  device has grabbed the physical keyboard, as a reminder that FG's normal
  keybindings are temporarily suspended.

#### App Icons

These should be self explanatory - "tap" an app icon to start or foreground
that app.

#### Navigation Buttons ("Softbuttons")

- The **back button** (left arrow) implements an application-defined "back"
  action, usually either navigating to a previous page, or hiding the on-screen
  keyboard.
- The **home button** (circle) takes you back to the home screen and suspends
  the currently active app. Clicking the home button again when already on the
  home screen opens the *app switcher*, where you can manage active apps.
- The **menu button** (square) currently does nothing. It could open the app
  switcher (instead of having to go through the home screen), or it could
  provide an app-specific menu function; this is as of yet undecided.

## The Charts App

![Charts app showing the main directory](img/charts-dir.jpg)

The Charts app simulates a set of charts stored on the device; however, because
most people don't have a stack of aviation charts on their disk, let alone
prepared for FG usage, we need to go through an external [companion
app](https://github.com/tdammers/fg-efb-server), which pulls charts from public
eAIP websites, and converts them from PDF (which FlightGear does not
understand) to JPG (which can easily be used as textures in FlightGear). The
companion app also takes care of converting the variety of eAIP websites out
there into a somewhat uniform structure.

The first thing you'll see if everything is configured correctly is a directory
listing. The top row is special: the "Home" icon takes you back to the
top-level directory, the "Favorites" button shows you the charts you have
currently favorited. Other than that, clicking on any folder icon takes you to
that folder, and clicking on a chart icon shows that chart.

The "back" softbutton takes you back to the previously viewed directory.

<p style="clear: both"/>

![Charts app showing a chart](img/charts-chartview.jpg)

When viewing a chart, some extra controls will show:
- a zoom/scroll control in the top-left corner, which does what you would
  expect
- a pager on the bottom, also fairly self-explanatory
- a "favorite" star in the top-right corner, which you can use to favorite or
  un-favorite this chart.

<p style="clear: both"/>

![Charts app error](img/charts-error.jpg)

Should you see this error message, then that means the companion app couldn't
be reached (see above); make sure it is installed and running, and that the EFB
is configured for the correct URL. With any error screen, you can use the
"reload" icon in the top right corner to try again after you have fixed the
problem.

Note that the companion URL needs to be configured separately for each aircraft
type, due to the way FlightGear stores such configurations.

## The Kneepad App

The Kneepad app is a simple text editor, designed to replace a paper kneepad
for taking notes while flying.

![Kneepad app **startup screen**](img/kneepad-blank.jpg)

By default, it starts up to a fairly spartan screen, with just an empty
off-white text area, and a menu with a single icon (the trash can).

From here, you can click the text area to start typing; an on-screen keyboard
will appear, and you can enter text. You can also click the trash can icon to
clear the kneepad - but careful, there is currently no "undo", so if you had
anything important in there, it will be lost. Future versions will probably
feature "undo", and may also be able to save and restore kneepad contents.

![Kneepad app in **text entry mode**.<br/>Note the keycap icon in the status
bar,<br/>indicating that the physical keyboard<br/>is currently grabbed](img/kneepad-editing.jpg)

To exit text entry mode, click the "back" softbutton; if keyboard grabbing is
enabled, the Esc key will also exit text entry mode.

Due to the limitations of the FG platform, it is not currently possible to
select text, copy-paste, etc.; I still have to think about a good UX for that.

Cursor keys are not currently captured, not even in keyboard grabbing mode, so
if you need to move around, you have to click to move the cursor.

In both modes, the scroll wheel will move the view up and down.

The position indicator in the top right corner shows you the current cursor
position; it will be grey in view mode, black in text entry mode.

## The Maps App

![Maps app,<br/>auto-centered](img/maps-centered.jpg)

The Maps app displays the current position and orientation on a moving map.

The zoom/scroll controls in the top-left corner work as you'd expect. Zooming
can also be achieved with the scroll wheel.

#### Auto-zooming

![Maps app,<br/>manually scrolled](img/maps-scrolled.jpg)

Clicking the square in the middle of the scroll arrow buttons will revert the
map to auto-scrolling mode, indicated by the red position symbol on the center
button. Scrolling in any direction will disable auto-scrolling.

#### Map Tile Caching

Map tiles are downloaded from OpenStreetMap tile servers, and cached locally in
`~/.fgfs/cache/maps/osm-tile` (or the equivalent on your OS). In the rare event
that things get borked up, you can delete that directory, but be advised that
this will cause all map tiles to be re-downloaded the next time you look at
them in the EFB.

## The Paperwork App

The Paperwork app replaces the physical Operational Flight Plan, allowing
pilots to view and fill in these documents digitally.

![Paperwork Startup Menu](img/paperwork-start.jpg)

When starting up, the Paperwork app will present a menu from where you can
select one of the available OFP's it has found. It will search in the following
locations (or their equivalents on your OS):

- `~/.fgfs/Export/simbrief.xml` (presented as "Load from SimBrief")
- `~/.fgfs/Export/OFP/*.xml` (presented by their respective file names)

Clicking any of these choices will "load" the OFP as the "Current OFP".
Careful; the app does not currently support saving your entered data (this is
planned for a future release though), and loading another flight plan will
discard the current one.

#### Importing from SimBrief

Note that the Paperwork app **does not fetch briefings from SimBrief itself;**
it only loads XML briefings from the local disk.

You can use the [SimBrief Importer
add-on](https://github.com/tdammers/fg-simbrief-addon/) to download OFP
briefings in XML format directly from SimBrief; the addon will store the
briefing as `simbrief.xml` in the exact location where the Paperwork app
expects it.

You can also manually navigate to
`https://www.simbrief.com/api/xml.fetcher.php?username={username}` (replace
`{username}` with your SimBrief username) and save the downloaded XML file in
`~/.fgfs/Export/OFP/`.

### Opening an OFP

![Paperwork Startup Menu,<br/>OFP loaded successfully](img/paperwork-loaded.jpg)

Once an OFP has been loaded successfully, it will show up in the "Current OFP"
section, now displaying the title as it appears inside the OFP itself.
Clicking that button will open the OFP and allow you to view and edit it.

### View Mode

![Paperwork in **OFP View Mode**](img/paperwork-view.jpg)

![Paperwork showing the **TOC Pane**](img/paperwork-toc.jpg)

In view mode, you can read the entire OFP in all its glory. The arrow on the
left will open the TOC Pane (table of contents), which gives quick access to
the various sections of the OFP. The pager at the bottom works as usual.

Clicking any of the grey boxes with dots will switch to entry mode, where you
can type directly into the OFP.

### Entry Mode

![Paperwork in **Entry Mode**](img/paperwork-entry.jpg)

In entry mode, the on-screen keyboard works as usual, and of course if keyboard
grabbing is available, the physical keyboard can be used too. To exit entry
mode:

- Use the Enter key to confirm your entry, or:
- Press Esc on the physical keyboard (if grabbed) to cancel the entry, or:
- Click the entry field again to cancel the entry, or:
- Click a different entry field to cancel the current entry and start editing
  the other field, or:
- Use the TOC Pane or pager to navigate away from the current page.

### Device Rotation

![Paperwork showing a map<br/>in **landscape orientation**](img/paperwork-map.jpg)

...is partially supported. When the device is rotated into landscape mode, the
OFP display orientation does not change, which is useful for the maps sections
(which are printed in landscape orientation). The pager will flip around for
easy page-flipping, however the TOC Pane and on-screen keyboard do not, so if
you need to enter anything, it's best to put the device back into a portrait
orientation.


