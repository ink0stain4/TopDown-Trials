if instance_exists(objFadeIn)
{instance_destroy(objFadeIn)}

instance_create_depth(x, y, -999999, objFadeIn)


if !instance_exists(objCameraManager)
instance_create_layer(-999, -999, "HUD_Elements", objCameraManager);

if !instance_exists(objParticleManager)
instance_create_layer(-999, -999, "HUD_Elements", objParticleManager);

if !instance_exists(objInventoryManager)
instance_create_layer(-999, -999, "HUD_Elements", objInventoryManager);