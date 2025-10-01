; https://www.autohotkey.com/boards/viewtopic.php?t=77668
vSync(guiName = 1)
{
	Gui %guiName%:+LastFound +E0x02000000 +E0x00080000
}