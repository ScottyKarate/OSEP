# VBA stomping refers to removing traces of VBA code in Word/Excel files.  FlexHex .DOC files

<br><br>

#### Tools required

1) FlexHex (Manual editing)
2) EvilClippy


### Manual Method steps
1) Replace the line '"Module=NewMacros"' with Zero Blocks
<br>
<img width="647" height="254" alt="image" src="https://github.com/user-attachments/assets/0780617b-5379-43d6-8bbe-88da1d2c742a" />
<br>

<br>

2) Scroll down to 'NewMacros' under macros and VBA and remove the code from statement 'Attribute VB_Name = "New Macros".' down to the bottom end byte.
   <img width="730" height="313" alt="image" src="https://github.com/user-attachments/assets/51853506-7e2c-4fa9-aa3a-bd7ea7bb98f0" />

   To the end byte:

   <img width="688" height="122" alt="image" src="https://github.com/user-attachments/assets/84856c7e-861a-4c1b-98e1-20b883ee61ed" />

