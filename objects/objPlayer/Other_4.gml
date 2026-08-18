//objPlayer Room Start
if instance_exists(objFadeIn)
{instance_destroy(objFadeIn)}

instance_create_depth(x, y, -999999, objFadeIn)


if !instance_exists(objCameraManager)
instance_create_layer(-999, -999, "HUD_Elements", objCameraManager);

if !instance_exists(objParticleManager)
instance_create_layer(-999, -999, "HUD_Elements", objParticleManager);

if !instance_exists(objGridSystem)
instance_create_layer(-999, -999, "Instances", objGridSystem);

if !instance_exists(objPathGridManager)
instance_create_layer(-999, -999, "Instances", objPathGridManager);

if !instance_exists(objInventoryManager)
instance_create_layer(-999, -999, "HUD_Elements", objInventoryManager);

if !instance_exists(objEntityManager)
instance_create_layer(-999, -999, "Instances", objEntityManager);

if !instance_exists(objEquipmentManager)
instance_create_layer(-999, -999, "HUD_Elements", objEquipmentManager);
