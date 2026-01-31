.method private hidebysig 
	instance void Update () cil managed 
{
	// Method begins at RVA 0x4a8e64
	// Header size: 12
	// Code size: 2000 (0x7d0)
	.maxstack 7
	.locals init (
		[0] class CelestialBody,
		[1] valuetype Vector3d,
		[2] valuetype [UnityEngine.CoreModule]UnityEngine.Vector3,
		[3] valuetype FlightGlobals/SpeedDisplayModes,
		[4] valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion
	)

	// if (!FlightGlobals.ready)
	IL_0000: ldsfld bool FlightGlobals::ready
	IL_0005: brtrue.s IL_001b
	// loop start (head: IL_0007)
		// switch (6)
		IL_0007: ldc.i4.6
		IL_0008: switch (IL_0007)
	// end loop

	// if (1 == 0)
	IL_0011: ldc.i4.1
	IL_0012: brtrue.s IL_001a

	// /*OpCode not supported: LdMemberToken*/;
	IL_0014: ldtoken method instance void KSP.UI.Screens.Flight.NavBall::Update()
	IL_0019: pop

	// return;
	IL_001a: ret

	// CelestialBody currentMainBody = FlightGlobals.currentMainBody;
	IL_001b: ldsfld class CelestialBody FlightGlobals::currentMainBody
	IL_0020: stloc.0
	// target = FlightGlobals.ActiveVessel.ReferenceTransform;
	IL_0021: ldarg.0
	IL_0022: call class Vessel FlightGlobals::get_ActiveVessel()
	IL_0027: dup
	// (no C# code)
	IL_0028: pop
	IL_0029: callvirt instance class [UnityEngine.CoreModule]UnityEngine.Transform Vessel::get_ReferenceTransform()
	IL_002e: dup
	IL_002f: pop
	// offsetGymbal = Quaternion.Euler(euler);
	IL_0030: call instance void KSP.UI.Screens.Flight.NavBall::set_target(class [UnityEngine.CoreModule]UnityEngine.Transform)
	IL_0035: ldarg.0
	// if (!FlightGlobals.ActiveVessel.isEVA)
	IL_0036: call class Vessel FlightGlobals::get_ActiveVessel()
	IL_003b: dup
	// (no C# code)
	IL_003c: pop
	IL_003d: callvirt instance bool Vessel::get_isEVA()
	IL_0042: dup
	// switch (3)
	IL_0043: pop
	IL_0044: brtrue.s IL_0058
	// loop start (head: IL_0046)
		IL_0046: ldc.i4.3
		IL_0047: switch (IL_0046)
	// end loop

	// euler = rotationOffset;
	IL_0050: ldarg.0
	IL_0051: ldfld valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 KSP.UI.Screens.Flight.NavBall::rotationOffset
	// (no C# code)
	IL_0056: br.s IL_006c

	// euler = new Vector3(0f, 0f, 0f);
	IL_0058: ldc.r4 0.0
	IL_005d: ldc.r4 0.0
	IL_0062: ldc.r4 0.0
	IL_0067: newobj instance void [UnityEngine.CoreModule]UnityEngine.Vector3::.ctor(float32, float32, float32)

	IL_006c: call valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion [UnityEngine.CoreModule]UnityEngine.Quaternion::Euler(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_0071: dup
	// (no C# code)
	IL_0072: pop
	// if (FlightGlobals.ActiveVessel.isEVA)
	IL_0073: call instance void KSP.UI.Screens.Flight.NavBall::set_offsetGymbal(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion)
	IL_0078: call class Vessel FlightGlobals::get_ActiveVessel()
	IL_007d: dup
	// (no C# code)
	IL_007e: pop
	IL_007f: callvirt instance bool Vessel::get_isEVA()
	IL_0084: dup
	// switch (6)
	IL_0085: pop
	IL_0086: brfalse IL_0129
	// loop start (head: IL_008b)
		IL_008b: ldc.i4.6
		IL_008c: switch (IL_008b)
	// end loop

	// if (!MapView.MapIsEnabled)
	IL_0095: call bool MapView::get_MapIsEnabled()
	IL_009a: dup
	// switch (1)
	IL_009b: pop
	IL_009c: brtrue IL_0129
	// loop start (head: IL_00a1)
		IL_00a1: ldc.i4.1
		IL_00a2: switch (IL_00a1)
	// end loop

	// if (FlightCamera.fetch != null)
	IL_00ab: ldsfld class FlightCamera FlightCamera::fetch
	IL_00b0: ldnull
	IL_00b1: call bool [UnityEngine.CoreModule]UnityEngine.Object::op_Inequality(class [UnityEngine.CoreModule]UnityEngine.Object, class [UnityEngine.CoreModule]UnityEngine.Object)
	IL_00b6: dup
	// switch (4)
	IL_00b7: pop
	IL_00b8: brfalse.s IL_0129
	// loop start (head: IL_00ba)
		IL_00ba: ldc.i4.4
		IL_00bb: switch (IL_00ba)
	// end loop

	// attitudeGymbal = Quaternion.Inverse(FlightCamera.fetch.getReferenceFrame() * Quaternion.AngleAxis(FlightCamera.fetch.camHdg * 57.29578f, Vector3.up) * Quaternion.AngleAxis(FlightCamera.fetch.camPitch * 57.29578f, Vector3.right));
	IL_00c4: ldarg.0
	IL_00c5: ldsfld class FlightCamera FlightCamera::fetch
	IL_00ca: callvirt instance valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion FlightCamera::getReferenceFrame()
	IL_00cf: dup
	// (no C# code)
	IL_00d0: pop
	IL_00d1: ldsfld class FlightCamera FlightCamera::fetch
	IL_00d6: ldfld float32 FlightCamera::camHdg
	IL_00db: ldc.r4 57.29578
	IL_00e0: mul
	IL_00e1: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Vector3::get_up()
	IL_00e6: dup
	IL_00e7: pop
	IL_00e8: call valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion [UnityEngine.CoreModule]UnityEngine.Quaternion::AngleAxis(float32, valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_00ed: dup
	IL_00ee: pop
	IL_00ef: call valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion [UnityEngine.CoreModule]UnityEngine.Quaternion::op_Multiply(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion, valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion)
	IL_00f4: dup
	IL_00f5: pop
	IL_00f6: ldsfld class FlightCamera FlightCamera::fetch
	IL_00fb: ldfld float32 FlightCamera::camPitch
	IL_0100: ldc.r4 57.29578
	IL_0105: mul
	IL_0106: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Vector3::get_right()
	IL_010b: dup
	IL_010c: pop
	IL_010d: call valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion [UnityEngine.CoreModule]UnityEngine.Quaternion::AngleAxis(float32, valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_0112: dup
	IL_0113: pop
	IL_0114: call valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion [UnityEngine.CoreModule]UnityEngine.Quaternion::op_Multiply(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion, valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion)
	IL_0119: dup
	IL_011a: pop
	IL_011b: call valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion [UnityEngine.CoreModule]UnityEngine.Quaternion::Inverse(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion)
	IL_0120: dup
	IL_0121: pop
	// goto IL_0154;
	IL_0122: call instance void KSP.UI.Screens.Flight.NavBall::set_attitudeGymbal(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion)
	IL_0127: br.s IL_0154

	// attitudeGymbal = offsetGymbal * Quaternion.Inverse(target.rotation);
	IL_0129: ldarg.0
	IL_012a: ldarg.0
	IL_012b: call instance valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion KSP.UI.Screens.Flight.NavBall::get_offsetGymbal()
	IL_0130: dup
	// (no C# code)
	IL_0131: pop
	IL_0132: ldarg.0
	IL_0133: call instance class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::get_target()
	IL_0138: dup
	IL_0139: pop
	IL_013a: callvirt instance valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion [UnityEngine.CoreModule]UnityEngine.Transform::get_rotation()
	IL_013f: dup
	IL_0140: pop
	IL_0141: call valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion [UnityEngine.CoreModule]UnityEngine.Quaternion::Inverse(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion)
	IL_0146: dup
	IL_0147: pop
	IL_0148: call valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion [UnityEngine.CoreModule]UnityEngine.Quaternion::op_Multiply(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion, valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion)
	IL_014d: dup
	IL_014e: pop
	// relativeGymbal = attitudeGymbal * Quaternion.LookRotation(Vector3.ProjectOnPlane(currentMainBody.position + (Vector3d)currentMainBody.transform.up * currentMainBody.Radius - target.position, (target.position - currentMainBody.position).normalized).normalized, (target.position - currentMainBody.position).normalized);
	IL_014f: call instance void KSP.UI.Screens.Flight.NavBall::set_attitudeGymbal(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion)

	IL_0154: ldarg.0
	IL_0155: ldarg.0
	IL_0156: call instance valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion KSP.UI.Screens.Flight.NavBall::get_attitudeGymbal()
	IL_015b: dup
	// (no C# code)
	IL_015c: pop
	IL_015d: ldloc.0
	IL_015e: callvirt instance valuetype Vector3d CelestialBody::get_position()
	IL_0163: dup
	IL_0164: pop
	IL_0165: ldloc.0
	IL_0166: callvirt instance class [UnityEngine.CoreModule]UnityEngine.Transform [UnityEngine.CoreModule]UnityEngine.Component::get_transform()
	IL_016b: dup
	IL_016c: pop
	IL_016d: callvirt instance valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Transform::get_up()
	IL_0172: dup
	IL_0173: pop
	IL_0174: call valuetype Vector3d Vector3d::op_Implicit(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_0179: dup
	IL_017a: pop
	IL_017b: ldloc.0
	IL_017c: ldfld float64 CelestialBody::Radius
	IL_0181: call valuetype Vector3d Vector3d::op_Multiply(valuetype Vector3d, float64)
	IL_0186: dup
	IL_0187: pop
	IL_0188: call valuetype Vector3d Vector3d::op_Addition(valuetype Vector3d, valuetype Vector3d)
	IL_018d: dup
	IL_018e: pop
	IL_018f: ldarg.0
	IL_0190: call instance class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::get_target()
	IL_0195: dup
	IL_0196: pop
	IL_0197: callvirt instance valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Transform::get_position()
	IL_019c: dup
	IL_019d: pop
	IL_019e: call valuetype Vector3d Vector3d::op_Subtraction(valuetype Vector3d, valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_01a3: dup
	IL_01a4: pop
	IL_01a5: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 Vector3d::op_Implicit(valuetype Vector3d)
	IL_01aa: dup
	IL_01ab: pop
	IL_01ac: ldarg.0
	IL_01ad: call instance class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::get_target()
	IL_01b2: dup
	IL_01b3: pop
	IL_01b4: callvirt instance valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Transform::get_position()
	IL_01b9: dup
	IL_01ba: pop
	IL_01bb: ldloc.0
	IL_01bc: callvirt instance valuetype Vector3d CelestialBody::get_position()
	IL_01c1: dup
	IL_01c2: pop
	IL_01c3: call valuetype Vector3d Vector3d::op_Subtraction(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3, valuetype Vector3d)
	IL_01c8: dup
	IL_01c9: pop
	IL_01ca: stloc.1
	IL_01cb: ldloca.s 1
	IL_01cd: call instance valuetype Vector3d Vector3d::get_normalized()
	IL_01d2: dup
	IL_01d3: pop
	IL_01d4: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 Vector3d::op_Implicit(valuetype Vector3d)
	IL_01d9: dup
	IL_01da: pop
	IL_01db: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Vector3::ProjectOnPlane(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3, valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_01e0: dup
	IL_01e1: pop
	IL_01e2: stloc.2
	IL_01e3: ldloca.s 2
	IL_01e5: call instance valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Vector3::get_normalized()
	IL_01ea: dup
	IL_01eb: pop
	IL_01ec: ldarg.0
	IL_01ed: call instance class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::get_target()
	IL_01f2: dup
	IL_01f3: pop
	IL_01f4: callvirt instance valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Transform::get_position()
	IL_01f9: dup
	IL_01fa: pop
	IL_01fb: ldloc.0
	IL_01fc: callvirt instance valuetype Vector3d CelestialBody::get_position()
	IL_0201: dup
	IL_0202: pop
	IL_0203: call valuetype Vector3d Vector3d::op_Subtraction(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3, valuetype Vector3d)
	IL_0208: dup
	IL_0209: pop
	IL_020a: stloc.1
	IL_020b: ldloca.s 1
	IL_020d: call instance valuetype Vector3d Vector3d::get_normalized()
	IL_0212: dup
	IL_0213: pop
	IL_0214: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 Vector3d::op_Implicit(valuetype Vector3d)
	IL_0219: dup
	IL_021a: pop
	IL_021b: call valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion [UnityEngine.CoreModule]UnityEngine.Quaternion::LookRotation(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3, valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_0220: dup
	IL_0221: pop
	IL_0222: call valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion [UnityEngine.CoreModule]UnityEngine.Quaternion::op_Multiply(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion, valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion)
	IL_0227: dup
	IL_0228: pop
	// navBall.rotation = relativeGymbal;
	IL_0229: call instance void KSP.UI.Screens.Flight.NavBall::set_relativeGymbal(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion)
	IL_022e: ldarg.0
	IL_022f: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::navBall
	IL_0234: ldarg.0
	IL_0235: call instance valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion KSP.UI.Screens.Flight.NavBall::get_relativeGymbal()
	IL_023a: dup
	// (no C# code)
	IL_023b: pop
	// switch (FlightGlobals.speedDisplayMode)
	IL_023c: callvirt instance void [UnityEngine.CoreModule]UnityEngine.Transform::set_rotation(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion)
	IL_0241: call valuetype FlightGlobals/SpeedDisplayModes FlightGlobals::get_speedDisplayMode()
	IL_0246: dup
	// (no C# code)
	IL_0247: pop
	IL_0248: stloc.3
	IL_0249: ldloc.3
	IL_024a: switch (IL_025d, IL_0273, IL_0289)

	// displayVelocity = FlightGlobals.ship_obtVelocity;
	IL_025b: br.s IL_029b

	IL_025d: ldarg.0
	IL_025e: call valuetype Vector3d FlightGlobals::get_ship_obtVelocity()
	IL_0263: dup
	// (no C# code)
	IL_0264: pop
	IL_0265: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 Vector3d::op_Implicit(valuetype Vector3d)
	IL_026a: dup
	// break;
	IL_026b: pop
	IL_026c: stfld valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 KSP.UI.Screens.Flight.NavBall::displayVelocity
	IL_0271: br.s IL_029b

	// displayVelocity = FlightGlobals.ship_srfVelocity;
	IL_0273: ldarg.0
	IL_0274: call valuetype Vector3d FlightGlobals::get_ship_srfVelocity()
	IL_0279: dup
	// (no C# code)
	IL_027a: pop
	IL_027b: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 Vector3d::op_Implicit(valuetype Vector3d)
	IL_0280: dup
	// break;
	IL_0281: pop
	IL_0282: stfld valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 KSP.UI.Screens.Flight.NavBall::displayVelocity
	IL_0287: br.s IL_029b

	// displayVelocity = FlightGlobals.ship_tgtVelocity;
	IL_0289: ldarg.0
	IL_028a: ldsfld valuetype Vector3d FlightGlobals::ship_tgtVelocity
	IL_028f: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 Vector3d::op_Implicit(valuetype Vector3d)
	IL_0294: dup
	// if (FlightGlobals.ActiveVessel.isEVA)
	IL_0295: pop
	IL_0296: stfld valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 KSP.UI.Screens.Flight.NavBall::displayVelocity

	IL_029b: call class Vessel FlightGlobals::get_ActiveVessel()
	IL_02a0: dup
	// (no C# code)
	IL_02a1: pop
	IL_02a2: callvirt instance bool Vessel::get_isEVA()
	IL_02a7: dup
	// switch (7)
	IL_02a8: pop
	IL_02a9: brfalse IL_03af
	// loop start (head: IL_02ae)
		IL_02ae: ldc.i4.7
		IL_02af: switch (IL_02ae)
	// end loop

	// if (FlightGlobals.ActiveVessel.LandedOrSplashed)
	IL_02b8: call class Vessel FlightGlobals::get_ActiveVessel()
	IL_02bd: dup
	// (no C# code)
	IL_02be: pop
	IL_02bf: callvirt instance bool Vessel::get_LandedOrSplashed()
	IL_02c4: dup
	// switch (5)
	IL_02c5: pop
	IL_02c6: brtrue.s IL_0312
	// loop start (head: IL_02c8)
		IL_02c8: ldc.i4.5
		IL_02c9: switch (IL_02c8)
	// end loop

	// if (FlightGlobals.ActiveVessel.heightFromTerrain >= 0f)
	IL_02d2: call class Vessel FlightGlobals::get_ActiveVessel()
	IL_02d7: dup
	// switch (7)
	IL_02d8: pop
	IL_02d9: ldfld float32 Vessel::heightFromTerrain
	IL_02de: ldc.r4 0.0
	IL_02e3: blt.un IL_03af
	// loop start (head: IL_02e8)
		IL_02e8: ldc.i4.7
		IL_02e9: switch (IL_02e8)
	// end loop

	// if (FlightGlobals.ActiveVessel.heightFromTerrain <= 1f)
	IL_02f2: call class Vessel FlightGlobals::get_ActiveVessel()
	IL_02f7: dup
	// switch (4)
	IL_02f8: pop
	IL_02f9: ldfld float32 Vessel::heightFromTerrain
	IL_02fe: ldc.r4 1
	IL_0303: bgt.un IL_03af
	// loop start (head: IL_0308)
		IL_0308: ldc.i4.4
		IL_0309: switch (IL_0308)
	// end loop

	// progradeVector.gameObject.SetActive(value: false);
	IL_0312: ldarg.0
	IL_0313: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::progradeVector
	IL_0318: callvirt instance class [UnityEngine.CoreModule]UnityEngine.GameObject [UnityEngine.CoreModule]UnityEngine.Component::get_gameObject()
	IL_031d: dup
	// (no C# code)
	IL_031e: pop
	IL_031f: ldc.i4.0
	// retrogradeVector.gameObject.SetActive(value: false);
	IL_0320: callvirt instance void [UnityEngine.CoreModule]UnityEngine.GameObject::SetActive(bool)
	IL_0325: ldarg.0
	IL_0326: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::retrogradeVector
	IL_032b: callvirt instance class [UnityEngine.CoreModule]UnityEngine.GameObject [UnityEngine.CoreModule]UnityEngine.Component::get_gameObject()
	IL_0330: dup
	// (no C# code)
	IL_0331: pop
	IL_0332: ldc.i4.0
	// normalVector.gameObject.SetActive(value: false);
	IL_0333: callvirt instance void [UnityEngine.CoreModule]UnityEngine.GameObject::SetActive(bool)
	IL_0338: ldarg.0
	IL_0339: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::normalVector
	IL_033e: callvirt instance class [UnityEngine.CoreModule]UnityEngine.GameObject [UnityEngine.CoreModule]UnityEngine.Component::get_gameObject()
	IL_0343: dup
	// (no C# code)
	IL_0344: pop
	IL_0345: ldc.i4.0
	// antiNormalVector.gameObject.SetActive(value: false);
	IL_0346: callvirt instance void [UnityEngine.CoreModule]UnityEngine.GameObject::SetActive(bool)
	IL_034b: ldarg.0
	IL_034c: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::antiNormalVector
	IL_0351: callvirt instance class [UnityEngine.CoreModule]UnityEngine.GameObject [UnityEngine.CoreModule]UnityEngine.Component::get_gameObject()
	IL_0356: dup
	// (no C# code)
	IL_0357: pop
	IL_0358: ldc.i4.0
	// radialInVector.gameObject.SetActive(value: false);
	IL_0359: callvirt instance void [UnityEngine.CoreModule]UnityEngine.GameObject::SetActive(bool)
	IL_035e: ldarg.0
	IL_035f: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::radialInVector
	IL_0364: callvirt instance class [UnityEngine.CoreModule]UnityEngine.GameObject [UnityEngine.CoreModule]UnityEngine.Component::get_gameObject()
	IL_0369: dup
	// (no C# code)
	IL_036a: pop
	IL_036b: ldc.i4.0
	// radialOutVector.gameObject.SetActive(value: false);
	IL_036c: callvirt instance void [UnityEngine.CoreModule]UnityEngine.GameObject::SetActive(bool)
	IL_0371: ldarg.0
	IL_0372: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::radialOutVector
	IL_0377: callvirt instance class [UnityEngine.CoreModule]UnityEngine.GameObject [UnityEngine.CoreModule]UnityEngine.Component::get_gameObject()
	IL_037c: dup
	// (no C# code)
	IL_037d: pop
	IL_037e: ldc.i4.0
	// progradeWaypoint.gameObject.SetActive(value: false);
	IL_037f: callvirt instance void [UnityEngine.CoreModule]UnityEngine.GameObject::SetActive(bool)
	IL_0384: ldarg.0
	IL_0385: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::progradeWaypoint
	IL_038a: callvirt instance class [UnityEngine.CoreModule]UnityEngine.GameObject [UnityEngine.CoreModule]UnityEngine.Component::get_gameObject()
	IL_038f: dup
	// (no C# code)
	IL_0390: pop
	IL_0391: ldc.i4.0
	// retrogradeWaypoint.gameObject.SetActive(value: false);
	IL_0392: callvirt instance void [UnityEngine.CoreModule]UnityEngine.GameObject::SetActive(bool)
	IL_0397: ldarg.0
	IL_0398: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::retrogradeWaypoint
	IL_039d: callvirt instance class [UnityEngine.CoreModule]UnityEngine.GameObject [UnityEngine.CoreModule]UnityEngine.Component::get_gameObject()
	IL_03a2: dup
	// (no C# code)
	IL_03a3: pop
	IL_03a4: ldc.i4.0
	// goto IL_06a5;
	IL_03a5: callvirt instance void [UnityEngine.CoreModule]UnityEngine.GameObject::SetActive(bool)
	IL_03aa: br IL_06a5

	// DrawOrbitalCues(FlightGlobals.speedDisplayMode == FlightGlobals.SpeedDisplayModes.Orbit);
	IL_03af: ldarg.0
	IL_03b0: call valuetype FlightGlobals/SpeedDisplayModes FlightGlobals::get_speedDisplayMode()
	IL_03b5: dup
	// (no C# code)
	IL_03b6: pop
	IL_03b7: ldc.i4.0
	IL_03b8: ceq
	// displaySpeed = displayVelocity.magnitude;
	IL_03ba: call instance void KSP.UI.Screens.Flight.NavBall::DrawOrbitalCues(bool)
	IL_03bf: ldarg.0
	IL_03c0: ldarg.0
	IL_03c1: ldflda valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 KSP.UI.Screens.Flight.NavBall::displayVelocity
	IL_03c6: call instance float32 [UnityEngine.CoreModule]UnityEngine.Vector3::get_magnitude()
	IL_03cb: dup
	// if (displaySpeed == 0f)
	IL_03cc: pop
	IL_03cd: stfld float32 KSP.UI.Screens.Flight.NavBall::displaySpeed
	IL_03d2: ldarg.0
	IL_03d3: ldfld float32 KSP.UI.Screens.Flight.NavBall::displaySpeed
	IL_03d8: ldc.r4 0.0
	IL_03dd: bne.un.s IL_03f4
	// loop start (head: IL_03df)
		// switch (3)
		IL_03df: ldc.i4.3
		IL_03e0: switch (IL_03df)
	// end loop

	// displaySpeed = 1E-06f;
	IL_03e9: ldarg.0
	IL_03ea: ldc.r4 1E-06
	IL_03ef: stfld float32 KSP.UI.Screens.Flight.NavBall::displaySpeed

	// displayVelDir = displayVelocity / displaySpeed;
	IL_03f4: ldarg.0
	IL_03f5: ldarg.0
	IL_03f6: ldfld valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 KSP.UI.Screens.Flight.NavBall::displayVelocity
	IL_03fb: ldarg.0
	IL_03fc: ldfld float32 KSP.UI.Screens.Flight.NavBall::displaySpeed
	IL_0401: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Vector3::op_Division(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3, float32)
	IL_0406: dup
	// GameObject obj = progradeVector.gameObject;
	IL_0407: pop
	IL_0408: stfld valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 KSP.UI.Screens.Flight.NavBall::displayVelDir
	IL_040d: ldarg.0
	IL_040e: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::progradeVector
	IL_0413: callvirt instance class [UnityEngine.CoreModule]UnityEngine.GameObject [UnityEngine.CoreModule]UnityEngine.Component::get_gameObject()
	IL_0418: dup
	// if (displaySpeed > vectorVelocityThreshold)
	IL_0419: pop
	IL_041a: ldarg.0
	IL_041b: ldfld float32 KSP.UI.Screens.Flight.NavBall::displaySpeed
	IL_0420: ldarg.0
	IL_0421: ldfld float32 KSP.UI.Screens.Flight.NavBall::vectorVelocityThreshold
	IL_0426: ble.un.s IL_0458
	// loop start (head: IL_0428)
		// switch (1)
		IL_0428: ldc.i4.1
		IL_0429: switch (IL_0428)
	// end loop

	// active = ((progradeVector.transform.localPosition.z >= vectorUnitCutoff) ? 1 : 0);
	IL_0432: ldarg.0
	IL_0433: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::progradeVector
	IL_0438: callvirt instance class [UnityEngine.CoreModule]UnityEngine.Transform [UnityEngine.CoreModule]UnityEngine.Component::get_transform()
	IL_043d: dup
	// (no C# code)
	IL_043e: pop
	IL_043f: callvirt instance valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Transform::get_localPosition()
	IL_0444: dup
	// active = 0;
	IL_0445: pop
	IL_0446: ldfld float32 [UnityEngine.CoreModule]UnityEngine.Vector3::z
	IL_044b: ldarg.0
	IL_044c: ldfld float32 KSP.UI.Screens.Flight.NavBall::vectorUnitCutoff
	IL_0451: clt.un
	IL_0453: ldc.i4.0
	IL_0454: ceq
	IL_0456: br.s IL_0459

	IL_0458: ldc.i4.0

	// obj.SetActive((byte)active != 0);
	IL_0459: callvirt instance void [UnityEngine.CoreModule]UnityEngine.GameObject::SetActive(bool)
	// progradeVector.localPosition = attitudeGymbal * (displayVelDir * vectorUnitScale);
	IL_045e: ldarg.0
	IL_045f: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::progradeVector
	IL_0464: ldarg.0
	IL_0465: call instance valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion KSP.UI.Screens.Flight.NavBall::get_attitudeGymbal()
	IL_046a: dup
	// (no C# code)
	IL_046b: pop
	IL_046c: ldarg.0
	IL_046d: ldfld valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 KSP.UI.Screens.Flight.NavBall::displayVelDir
	IL_0472: ldarg.0
	IL_0473: ldfld float32 KSP.UI.Screens.Flight.NavBall::vectorUnitScale
	IL_0478: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Vector3::op_Multiply(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3, float32)
	IL_047d: dup
	IL_047e: pop
	IL_047f: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Quaternion::op_Multiply(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion, valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_0484: dup
	IL_0485: pop
	// GameObject obj2 = retrogradeVector.gameObject;
	IL_0486: callvirt instance void [UnityEngine.CoreModule]UnityEngine.Transform::set_localPosition(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_048b: ldarg.0
	IL_048c: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::retrogradeVector
	IL_0491: callvirt instance class [UnityEngine.CoreModule]UnityEngine.GameObject [UnityEngine.CoreModule]UnityEngine.Component::get_gameObject()
	IL_0496: dup
	// if (displaySpeed > vectorVelocityThreshold)
	IL_0497: pop
	IL_0498: ldarg.0
	IL_0499: ldfld float32 KSP.UI.Screens.Flight.NavBall::displaySpeed
	IL_049e: ldarg.0
	IL_049f: ldfld float32 KSP.UI.Screens.Flight.NavBall::vectorVelocityThreshold
	IL_04a4: ble.un.s IL_04d3
	// loop start (head: IL_04a6)
		// switch (7)
		IL_04a6: ldc.i4.7
		IL_04a7: switch (IL_04a6)
	// end loop

	// active2 = ((retrogradeVector.transform.localPosition.z > vectorUnitCutoff) ? 1 : 0);
	IL_04b0: ldarg.0
	IL_04b1: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::retrogradeVector
	IL_04b6: callvirt instance class [UnityEngine.CoreModule]UnityEngine.Transform [UnityEngine.CoreModule]UnityEngine.Component::get_transform()
	IL_04bb: dup
	// (no C# code)
	IL_04bc: pop
	IL_04bd: callvirt instance valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Transform::get_localPosition()
	IL_04c2: dup
	// active2 = 0;
	IL_04c3: pop
	IL_04c4: ldfld float32 [UnityEngine.CoreModule]UnityEngine.Vector3::z
	IL_04c9: ldarg.0
	IL_04ca: ldfld float32 KSP.UI.Screens.Flight.NavBall::vectorUnitCutoff
	IL_04cf: cgt
	IL_04d1: br.s IL_04d4

	IL_04d3: ldc.i4.0

	// obj2.SetActive((byte)active2 != 0);
	IL_04d4: callvirt instance void [UnityEngine.CoreModule]UnityEngine.GameObject::SetActive(bool)
	// retrogradeVector.localPosition = attitudeGymbal * (-displayVelDir * vectorUnitScale);
	IL_04d9: ldarg.0
	IL_04da: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::retrogradeVector
	IL_04df: ldarg.0
	IL_04e0: call instance valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion KSP.UI.Screens.Flight.NavBall::get_attitudeGymbal()
	IL_04e5: dup
	// (no C# code)
	IL_04e6: pop
	IL_04e7: ldarg.0
	IL_04e8: ldfld valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 KSP.UI.Screens.Flight.NavBall::displayVelDir
	IL_04ed: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Vector3::op_UnaryNegation(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_04f2: dup
	IL_04f3: pop
	IL_04f4: ldarg.0
	IL_04f5: ldfld float32 KSP.UI.Screens.Flight.NavBall::vectorUnitScale
	IL_04fa: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Vector3::op_Multiply(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3, float32)
	IL_04ff: dup
	IL_0500: pop
	IL_0501: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Quaternion::op_Multiply(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion, valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_0506: dup
	IL_0507: pop
	// GameObject obj3 = progradeWaypoint.gameObject;
	IL_0508: callvirt instance void [UnityEngine.CoreModule]UnityEngine.Transform::set_localPosition(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_050d: ldarg.0
	IL_050e: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::progradeWaypoint
	IL_0513: callvirt instance class [UnityEngine.CoreModule]UnityEngine.GameObject [UnityEngine.CoreModule]UnityEngine.Component::get_gameObject()
	IL_0518: dup
	// if (FlightGlobals.fetch.vesselTargetTransform != null)
	IL_0519: pop
	IL_051a: call class FlightGlobals FlightGlobals::get_fetch()
	IL_051f: dup
	// (no C# code)
	IL_0520: pop
	IL_0521: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform FlightGlobals::vesselTargetTransform
	IL_0526: ldnull
	IL_0527: call bool [UnityEngine.CoreModule]UnityEngine.Object::op_Inequality(class [UnityEngine.CoreModule]UnityEngine.Object, class [UnityEngine.CoreModule]UnityEngine.Object)
	IL_052c: dup
	// switch (5)
	IL_052d: pop
	IL_052e: brfalse.s IL_0560
	// loop start (head: IL_0530)
		IL_0530: ldc.i4.5
		IL_0531: switch (IL_0530)
	// end loop

	// active3 = ((progradeWaypoint.transform.localPosition.z >= vectorUnitCutoff) ? 1 : 0);
	IL_053a: ldarg.0
	IL_053b: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::progradeWaypoint
	IL_0540: callvirt instance class [UnityEngine.CoreModule]UnityEngine.Transform [UnityEngine.CoreModule]UnityEngine.Component::get_transform()
	IL_0545: dup
	// (no C# code)
	IL_0546: pop
	IL_0547: callvirt instance valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Transform::get_localPosition()
	IL_054c: dup
	// active3 = 0;
	IL_054d: pop
	IL_054e: ldfld float32 [UnityEngine.CoreModule]UnityEngine.Vector3::z
	IL_0553: ldarg.0
	IL_0554: ldfld float32 KSP.UI.Screens.Flight.NavBall::vectorUnitCutoff
	IL_0559: clt.un
	IL_055b: ldc.i4.0
	IL_055c: ceq
	IL_055e: br.s IL_0561

	IL_0560: ldc.i4.0

	// obj3.SetActive((byte)active3 != 0);
	IL_0561: callvirt instance void [UnityEngine.CoreModule]UnityEngine.GameObject::SetActive(bool)
	// if (FlightGlobals.fetch.vesselTargetDirection != Vector3.zero)
	IL_0566: call class FlightGlobals FlightGlobals::get_fetch()
	IL_056b: dup
	// (no C# code)
	IL_056c: pop
	IL_056d: ldfld valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 FlightGlobals::vesselTargetDirection
	IL_0572: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Vector3::get_zero()
	IL_0577: dup
	IL_0578: pop
	IL_0579: call bool [UnityEngine.CoreModule]UnityEngine.Vector3::op_Inequality(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3, valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_057e: dup
	// switch (1)
	IL_057f: pop
	IL_0580: brfalse.s IL_05bf
	// loop start (head: IL_0582)
		IL_0582: ldc.i4.1
		IL_0583: switch (IL_0582)
	// end loop

	// progradeWaypoint.localPosition = attitudeGymbal * FlightGlobals.fetch.vesselTargetDirection * vectorUnitScale;
	IL_058c: ldarg.0
	IL_058d: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::progradeWaypoint
	IL_0592: ldarg.0
	IL_0593: call instance valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion KSP.UI.Screens.Flight.NavBall::get_attitudeGymbal()
	IL_0598: dup
	// (no C# code)
	IL_0599: pop
	IL_059a: call class FlightGlobals FlightGlobals::get_fetch()
	IL_059f: dup
	IL_05a0: pop
	IL_05a1: ldfld valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 FlightGlobals::vesselTargetDirection
	IL_05a6: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Quaternion::op_Multiply(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion, valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_05ab: dup
	IL_05ac: pop
	IL_05ad: ldarg.0
	IL_05ae: ldfld float32 KSP.UI.Screens.Flight.NavBall::vectorUnitScale
	IL_05b3: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Vector3::op_Multiply(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3, float32)
	IL_05b8: dup
	IL_05b9: pop
	// GameObject obj4 = retrogradeWaypoint.gameObject;
	IL_05ba: callvirt instance void [UnityEngine.CoreModule]UnityEngine.Transform::set_localPosition(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)

	IL_05bf: ldarg.0
	IL_05c0: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::retrogradeWaypoint
	IL_05c5: callvirt instance class [UnityEngine.CoreModule]UnityEngine.GameObject [UnityEngine.CoreModule]UnityEngine.Component::get_gameObject()
	IL_05ca: dup
	// if (FlightGlobals.fetch.vesselTargetTransform != null)
	IL_05cb: pop
	IL_05cc: call class FlightGlobals FlightGlobals::get_fetch()
	IL_05d1: dup
	// (no C# code)
	IL_05d2: pop
	IL_05d3: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform FlightGlobals::vesselTargetTransform
	IL_05d8: ldnull
	IL_05d9: call bool [UnityEngine.CoreModule]UnityEngine.Object::op_Inequality(class [UnityEngine.CoreModule]UnityEngine.Object, class [UnityEngine.CoreModule]UnityEngine.Object)
	IL_05de: dup
	// switch (4)
	IL_05df: pop
	IL_05e0: brfalse.s IL_060f
	// loop start (head: IL_05e2)
		IL_05e2: ldc.i4.4
		IL_05e3: switch (IL_05e2)
	// end loop

	// active4 = ((retrogradeWaypoint.transform.localPosition.z > vectorUnitCutoff) ? 1 : 0);
	IL_05ec: ldarg.0
	IL_05ed: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::retrogradeWaypoint
	IL_05f2: callvirt instance class [UnityEngine.CoreModule]UnityEngine.Transform [UnityEngine.CoreModule]UnityEngine.Component::get_transform()
	IL_05f7: dup
	// (no C# code)
	IL_05f8: pop
	IL_05f9: callvirt instance valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Transform::get_localPosition()
	IL_05fe: dup
	// active4 = 0;
	IL_05ff: pop
	IL_0600: ldfld float32 [UnityEngine.CoreModule]UnityEngine.Vector3::z
	IL_0605: ldarg.0
	IL_0606: ldfld float32 KSP.UI.Screens.Flight.NavBall::vectorUnitCutoff
	IL_060b: cgt
	IL_060d: br.s IL_0610

	IL_060f: ldc.i4.0

	// obj4.SetActive((byte)active4 != 0);
	IL_0610: callvirt instance void [UnityEngine.CoreModule]UnityEngine.GameObject::SetActive(bool)
	// if (FlightGlobals.fetch.vesselTargetDirection != Vector3.zero)
	IL_0615: call class FlightGlobals FlightGlobals::get_fetch()
	IL_061a: dup
	// (no C# code)
	IL_061b: pop
	IL_061c: ldfld valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 FlightGlobals::vesselTargetDirection
	IL_0621: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Vector3::get_zero()
	IL_0626: dup
	IL_0627: pop
	IL_0628: call bool [UnityEngine.CoreModule]UnityEngine.Vector3::op_Inequality(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3, valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_062d: dup
	// switch (7)
	IL_062e: pop
	IL_062f: brfalse.s IL_0675
	// loop start (head: IL_0631)
		IL_0631: ldc.i4.7
		IL_0632: switch (IL_0631)
	// end loop

	// retrogradeWaypoint.localPosition = attitudeGymbal * -FlightGlobals.fetch.vesselTargetDirection * vectorUnitScale;
	IL_063b: ldarg.0
	IL_063c: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::retrogradeWaypoint
	IL_0641: ldarg.0
	IL_0642: call instance valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion KSP.UI.Screens.Flight.NavBall::get_attitudeGymbal()
	IL_0647: dup
	// (no C# code)
	IL_0648: pop
	IL_0649: call class FlightGlobals FlightGlobals::get_fetch()
	IL_064e: dup
	IL_064f: pop
	IL_0650: ldfld valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 FlightGlobals::vesselTargetDirection
	IL_0655: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Vector3::op_UnaryNegation(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_065a: dup
	IL_065b: pop
	IL_065c: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Quaternion::op_Multiply(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion, valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)
	IL_0661: dup
	IL_0662: pop
	IL_0663: ldarg.0
	IL_0664: ldfld float32 KSP.UI.Screens.Flight.NavBall::vectorUnitScale
	IL_0669: call valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Vector3::op_Multiply(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3, float32)
	IL_066e: dup
	IL_066f: pop
	// SetVectorAlphaTint(progradeVector);
	IL_0670: callvirt instance void [UnityEngine.CoreModule]UnityEngine.Transform::set_localPosition(valuetype [UnityEngine.CoreModule]UnityEngine.Vector3)

	IL_0675: ldarg.0
	IL_0676: ldarg.0
	IL_0677: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::progradeVector
	IL_067c: call instance void KSP.UI.Screens.Flight.NavBall::SetVectorAlphaTint(class [UnityEngine.CoreModule]UnityEngine.Transform)
	// SetVectorAlphaTint(retrogradeVector);
	IL_0681: ldarg.0
	IL_0682: ldarg.0
	IL_0683: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::retrogradeVector
	IL_0688: call instance void KSP.UI.Screens.Flight.NavBall::SetVectorAlphaTint(class [UnityEngine.CoreModule]UnityEngine.Transform)
	// SetVectorAlphaTint(progradeWaypoint);
	IL_068d: ldarg.0
	IL_068e: ldarg.0
	IL_068f: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::progradeWaypoint
	IL_0694: call instance void KSP.UI.Screens.Flight.NavBall::SetVectorAlphaTint(class [UnityEngine.CoreModule]UnityEngine.Transform)
	// SetVectorAlphaTint(retrogradeWaypoint);
	IL_0699: ldarg.0
	IL_069a: ldarg.0
	IL_069b: ldfld class [UnityEngine.CoreModule]UnityEngine.Transform KSP.UI.Screens.Flight.NavBall::retrogradeWaypoint
	IL_06a0: call instance void KSP.UI.Screens.Flight.NavBall::SetVectorAlphaTint(class [UnityEngine.CoreModule]UnityEngine.Transform)

	// if (FlightGlobals.ActiveVessel.situation == Vessel.Situations.PRELAUNCH)
	IL_06a5: call class Vessel FlightGlobals::get_ActiveVessel()
	IL_06aa: dup
	// switch (4)
	IL_06ab: pop
	IL_06ac: ldfld valuetype Vessel/Situations Vessel::situation
	IL_06b1: ldc.i4.4
	IL_06b2: bne.un IL_0786
	// loop start (head: IL_06b7)
		IL_06b7: ldc.i4.4
		IL_06b8: switch (IL_06b7)
	// end loop

	// if (FlightGlobals.ActiveVessel.ctrlState.pitch == 0f)
	IL_06c1: call class Vessel FlightGlobals::get_ActiveVessel()
	IL_06c6: dup
	// switch (7)
	IL_06c7: pop
	IL_06c8: ldfld class FlightCtrlState Vessel::ctrlState
	IL_06cd: ldfld float32 FlightCtrlState::pitch
	IL_06d2: ldc.r4 0.0
	IL_06d7: bne.un.s IL_073c
	// loop start (head: IL_06d9)
		IL_06d9: ldc.i4.7
		IL_06da: switch (IL_06d9)
	// end loop

	// if (FlightGlobals.ActiveVessel.ctrlState.yaw == 0f)
	IL_06e3: call class Vessel FlightGlobals::get_ActiveVessel()
	IL_06e8: dup
	// switch (1)
	IL_06e9: pop
	IL_06ea: ldfld class FlightCtrlState Vessel::ctrlState
	IL_06ef: ldfld float32 FlightCtrlState::yaw
	IL_06f4: ldc.r4 0.0
	IL_06f9: bne.un.s IL_073c
	// loop start (head: IL_06fb)
		IL_06fb: ldc.i4.1
		IL_06fc: switch (IL_06fb)
	// end loop

	// if (FlightGlobals.ActiveVessel.ctrlState.roll == 0f)
	IL_0705: call class Vessel FlightGlobals::get_ActiveVessel()
	IL_070a: dup
	// switch (6)
	IL_070b: pop
	IL_070c: ldfld class FlightCtrlState Vessel::ctrlState
	IL_0711: ldfld float32 FlightCtrlState::roll
	IL_0716: ldc.r4 0.0
	IL_071b: bne.un.s IL_073c
	// loop start (head: IL_071d)
		IL_071d: ldc.i4.6
		IL_071e: switch (IL_071d)
	// end loop

	// if (initialHeadingSet)
	IL_0727: ldarg.0
	IL_0728: ldfld bool KSP.UI.Screens.Flight.NavBall::initialHeadingSet
	IL_072d: brtrue IL_07cf
	// loop start (head: IL_0732)
		// switch (4)
		IL_0732: ldc.i4.4
		IL_0733: switch (IL_0732)
	// end loop

	// headingText.text = KSPUtil.LocalizeNumber(Quaternion.Inverse(relativeGymbal).eulerAngles.y, "000") + "°";
	IL_073c: ldarg.0
	IL_073d: ldfld class TMPro.TextMeshProUGUI KSP.UI.Screens.Flight.NavBall::headingText
	IL_0742: ldarg.0
	IL_0743: call instance valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion KSP.UI.Screens.Flight.NavBall::get_relativeGymbal()
	IL_0748: dup
	// (no C# code)
	IL_0749: pop
	IL_074a: call valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion [UnityEngine.CoreModule]UnityEngine.Quaternion::Inverse(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion)
	IL_074f: dup
	IL_0750: pop
	IL_0751: stloc.s 4
	IL_0753: ldloca.s 4
	IL_0755: call instance valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Quaternion::get_eulerAngles()
	IL_075a: dup
	IL_075b: pop
	IL_075c: ldfld float32 [UnityEngine.CoreModule]UnityEngine.Vector3::y
	IL_0761: ldstr "000"
	IL_0766: call string KSPUtil::LocalizeNumber(float32, string)
	IL_076b: dup
	IL_076c: pop
	IL_076d: ldstr "°"
	IL_0772: call string [mscorlib]System.String::Concat(string, string)
	IL_0777: dup
	IL_0778: pop
	// initialHeadingSet = true;
	IL_0779: callvirt instance void TMPro.TMP_Text::set_text(string)
	IL_077e: ldarg.0
	IL_077f: ldc.i4.1
	IL_0780: stfld bool KSP.UI.Screens.Flight.NavBall::initialHeadingSet
	// return;
	IL_0785: ret

	// headingText.text = KSPUtil.LocalizeNumber(Quaternion.Inverse(relativeGymbal).eulerAngles.y, "000") + "°";
	IL_0786: ldarg.0
	IL_0787: ldfld class TMPro.TextMeshProUGUI KSP.UI.Screens.Flight.NavBall::headingText
	IL_078c: ldarg.0
	IL_078d: call instance valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion KSP.UI.Screens.Flight.NavBall::get_relativeGymbal()
	IL_0792: dup
	// (no C# code)
	IL_0793: pop
	IL_0794: call valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion [UnityEngine.CoreModule]UnityEngine.Quaternion::Inverse(valuetype [UnityEngine.CoreModule]UnityEngine.Quaternion)
	IL_0799: dup
	IL_079a: pop
	IL_079b: stloc.s 4
	IL_079d: ldloca.s 4
	IL_079f: call instance valuetype [UnityEngine.CoreModule]UnityEngine.Vector3 [UnityEngine.CoreModule]UnityEngine.Quaternion::get_eulerAngles()
	IL_07a4: dup
	IL_07a5: pop
	IL_07a6: ldfld float32 [UnityEngine.CoreModule]UnityEngine.Vector3::y
	IL_07ab: ldstr "000"
	IL_07b0: call string KSPUtil::LocalizeNumber(float32, string)
	IL_07b5: dup
	IL_07b6: pop
	IL_07b7: ldstr "°"
	IL_07bc: call string [mscorlib]System.String::Concat(string, string)
	IL_07c1: dup
	IL_07c2: pop
	// initialHeadingSet = true;
	IL_07c3: callvirt instance void TMPro.TMP_Text::set_text(string)
	IL_07c8: ldarg.0
	IL_07c9: ldc.i4.1
	IL_07ca: stfld bool KSP.UI.Screens.Flight.NavBall::initialHeadingSet

	// }
	IL_07cf: ret
} // end of method NavBall::Update
