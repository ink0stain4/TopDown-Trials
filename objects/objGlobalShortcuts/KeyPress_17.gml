// Key Press - Tab
if (!instance_exists(objPlayer))
{
	exit;
}

if (instance_exists(objMenu))
{
	instance_destroy(objMenu);
}
else

pauseMenu()