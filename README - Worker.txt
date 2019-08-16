GRDHD HANDS GUI Version 3.4

******************************************************************************

 ORIGINAL CODE BY KYLE ROSS. Label and form functions developed by Daniel McFeeters.


 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

 These license terms may also be modified by the LOCAL DISTRIBUTION EXCEPTION
 described in the accompanying LICENSE.txt file.

******************************************************************************

To properly use the HANDS GUI, you must first install FreeFileSync and PDFTK. Both of these install files are located in the HANDS GUI folder for ease of deployment.

To use the HANDS GUI, run the executable deployment file labeled for the position you fill (Data, Worker, Supervisor). This executable will copy down from the GRDHD server the proper GUI program, an image file used within the program, this README file, and create a desktop shortcut to the GUI. The GUI requires no installation of its own.

-------------------------------------------------------------------------------
Changelog
-------------------------------------------------------------------------------
0.0 Beta Released
0.1 Minor changes for bug fixes
0.2 Added caseload GUI for data, worker, supervisor. Added label gui for Data

1.0 Launch
Created Goal GUI
Caseload GUI:
	supervisor - Access current, access previous, archive current (and create new)
	worker - Access current, access previous
Charts GUI:
	make charts gui 50% wider.
	stay in chart and ability to switch pages instead of returning (when error from empty folder)
Needs Corrections:
	supervisor - remove file to chart
Page Find:
	Add ASQ3's to page find (page 5 of child's chart)
Activities:
	make activitiese gui (worker) 100% wider
to supervisor
	fix rename button
	make it reopen the "to supervisor" folder when sending to corrections
Supervisor
	make a buton that opens a supervisor folder in windows explorer
Worker
	remove edit buton for labels
	create ASQ3/ASQ:SE button for forms
worker / supervisor
	modify the supervision button
	Two forms: weekly supervision (only seen by supervisor) PACKET A
	6 month form (signed by worker every week) Supplement FORM A
file to chart
	if path not found, force create
Make visit complete signature forms not go to supervisor
Make worker version check for free file sync before sync
Add a search function for charts (when viewing or filing)

1.1 Worker - made labels search look for string anywhere in name, rather than just first characters.
		corrected @_LCDHD_FORMDATE References in forms.au3 to @_GRDHD_FORMDATE
		add delete and rename functions to work in progress
    Data - made labels search look for string anywhere in name, rather than just first characters.

1.2
Change page find to match form names that include a timeframe (family status)
open to supervisor, rename button
add handout button to worker
check if file exists in chart before filing, give the option to rename file.
worker - made ASQ button change form path to the asq folder
Add button for worker to queue back to supervisor after signature
Data GUI add survey to sign button so data can send to worker for signature

1.3
Changed the "send to worker for signature" to reference the worker only for the destination, and the survey taking worker for source.

1.4
Added "RN SW log" and "Home inventory" forms to the chart page find

1.5
changed $fc_createpath variable to $FC_CREATEPATH.
This should allow folders to be created when filing, if the path does not exist.
Added page find for ASQSE and Service Record
created a variable for caseload file type

1.6
added ability to open other user's caseloads.
supervisor folder for data gui
completed visit archive (rework)

remove 3 message boxes when opening wkly supervision form GUI SV.
add search option for GUI forms in GUI worker
hands signature sync to ind. 

1.7
Fixed the pathing for handouts and activities

1.8
rebuilt caseload archive naming gui for drop down list instead of date picker
fixed bug causing all files to be moved (didn't have a catch for no selection)
added createpath tag to move command for caseloads
changed supervisor's open completed visits to the correct path
allowed supervisors completed visit archive to open a folder dynamically
added create new user button for supervisor

1.9
set GUI to delay appearing until after sync finishes
added caseload button to the open to data gui
removed "weekly supervision" column from supervisor window
added icacls permission changes for moving "surveys to sign"

2.0
Made goal gui not exit when closed, but instead go to main window.
made worker supervision button not delete the GUI
Make label name include billing code
6 month supervision form not syncing properly
Make the caseloads button in the to data gui go back to the to data screen
ensured the send to supervisor gui deleted itself when it detects that the folder is empty
readded caseload button to data main window
To Data GUI, rename button. When closed goes to charts gui
When canceling the rename operation, the file is still renamed

2.1
switched caseloads to excel

2.2
added page selection button and gui for moving from one page of a patient's chart to another.

2.3
made weekly supervision archive into folders (year\month) - Supervision Packet A

2.4
made archive function for supervision check to make sure there is valid input.
added change date and rename function to needs corrections window for worker
added FC_OVERWRITE to visit complete transmittal
added "to data" button so supervisors can check the to data folder of workers.
Removed the non-functional "file" button from completed visits archive GUI.

2.5
Made Sync check to see if power pdf is closed before it syncs
remove the file button from completed visits and completed visits archive GUIs (supervisor).
add a confirmation to deleting labels

3.0
Changed worker supervision to look directly at server instead of syncing copy
divide sync into two way and one way files
seperate readme into three versions

3.1
process check for gui, to make sure only one is open.
resized corrections gui to make change name/date buttons visible

3.2
server change

3.3
fixed static reference to old server in caseload code

3.4
changed workpath reference in corrections name change functions to correctionpath. 