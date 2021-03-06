#include "tensor.h"

#include <math_functions.h>
#define __spec __device__ __forceinline__

// determinant of a 3x3 symmetric tensor
__spec
float
det(symtensor3 const& T)
{
	float ret = 0;
	ret += T.xx*(T.yy*T.zz - T.yz*T.yz);
	ret -= T.xy*(T.xy*T.zz - T.xz*T.yz);
	ret += T.xz*(T.xy*T.yz - T.xz*T.yy);
	return ret;
}

// determinant of a 4x4 symmetric tensor
__spec
float
det(symtensor4 const& T)
{
	float ret = 0;

	// first minor: ww * (xyz × xyz)
	float M = 0;
	M += T.xx*(T.yy*T.zz - T.yz*T.yz);
	M -= T.xy*(T.xy*T.zz - T.xz*T.yz);
	M += T.xz*(T.xy*T.yz - T.xz*T.yy);
	ret += M*T.ww;

	// second minor: -zw * (xyz × xyw)
	M = 0;
	M += T.xx*(T.yy*T.zw - T.yz*T.yw);
	M -= T.xy*(T.xy*T.zw - T.xz*T.yw);
	M += T.xw*(T.xy*T.yz - T.xz*T.yy);
	ret -= M*T.zw;

	// third minor: yw * (xyz × xzw)
	M = 0;
	M += T.xx*(T.yz*T.zw - T.zz*T.yw);
	M -= T.xz*(T.xy*T.zw - T.xz*T.yw);
	M += T.xw*(T.xy*T.zz - T.xz*T.yz);
	ret += M*T.yw;

	// last minor: xw * (xyz × yzw)
	M = 0;
	M += T.xy*(T.yz*T.zw - T.zz*T.yw);
	M -= T.xz*(T.yy*T.zw - T.yz*T.yw);
	M += T.xw*(T.yy*T.zz - T.yz*T.yz);
	ret -= M*T.xw;

	return ret;
}

// L-infinity norm of a symmetric 4x4 tensor
__spec
float
norm_inf(symtensor4 const& T)
{
	float m = fmax(T.xx, T.xy);
	m = fmax(m, T.xz);
	m = fmax(m, T.xw);
	m = fmax(m, T.yy);
	m = fmax(m, T.yz);
	m = fmax(m, T.yw);
	m = fmax(m, T.zz);
	m = fmax(m, T.zw);
	m = fmax(m, T.ww);
	return m;
}

__spec
symtensor3
inverse(symtensor3 const& T)
{
	symtensor3 R;
	float D(det(T));
	R.xx = (T.yy*T.zz - T.yz*T.yz)/D;
	R.xy = (T.xz*T.yz - T.xy*T.zz)/D;
	R.xz = (T.xy*T.yz - T.xz*T.yy)/D;
	R.yy = (T.xx*T.zz - T.xz*T.xz)/D;
	R.yz = (T.xz*T.xy - T.xx*T.yz)/D;
	R.zz = (T.xx*T.yy - T.xy*T.xy)/D;

	return R;
}

__spec
symtensor3
operator -(symtensor3 const& T1, symtensor3 const& T2)
{
	symtensor3 R;
	R.xx = T1.xx - T2.xx;
	R.xy = T1.xy - T2.xy;
	R.xz = T1.xz - T2.xz;
	R.yy = T1.yy - T2.yy;
	R.yz = T1.yz - T2.yz;
	R.zz = T1.zz - T2.zz;
	return R;
}

__spec
symtensor3
operator +(symtensor3 const& T1, symtensor3 const& T2)
{
	symtensor3 R;
	R.xx = T1.xx + T2.xx;
	R.xy = T1.xy + T2.xy;
	R.xz = T1.xz + T2.xz;
	R.yy = T1.yy + T2.yy;
	R.yz = T1.yz + T2.yz;
	R.zz = T1.zz + T2.zz;
	return R;
}

__spec
symtensor3 &
operator -=(symtensor3 &T1, symtensor3 const& T2)
{
	T1.xx -= T2.xx;
	T1.xy -= T2.xy;
	T1.xz -= T2.xz;
	T1.yy -= T2.yy;
	T1.yz -= T2.yz;
	T1.zz -= T2.zz;
	return T1;
}

__spec
symtensor3 &
operator +=(symtensor3 &T1, symtensor3 const& T2)
{
	T1.xx += T2.xx;
	T1.xy += T2.xy;
	T1.xz += T2.xz;
	T1.yy += T2.yy;
	T1.yz += T2.yz;
	T1.zz += T2.zz;
	return T1;
}

__spec
symtensor3
operator /(symtensor3 const& T1, float f)
{
	symtensor3 R;
	R.xx = T1.xx/f;
	R.xy = T1.xy/f;
	R.xz = T1.xz/f;
	R.yy = T1.yy/f;
	R.yz = T1.yz/f;
	R.zz = T1.zz/f;
	return R;
}


__spec
symtensor3 &
operator /=(symtensor3 &T1, float f)
{
	T1.xx /= f;
	T1.xy /= f;
	T1.xz /= f;
	T1.yy /= f;
	T1.yz /= f;
	T1.zz /= f;
	return T1;
}

__spec
float3
dot(symtensor3 const& T, float3 const& v)
{
	return make_float3(
			T.xx*v.x + T.xy*v.y + T.xz*v.z,
			T.xy*v.y + T.yy*v.y + T.yz*v.z,
			T.xz*v.x + T.yz*v.y + T.zz*v.z);

}

__spec
float3
dot(symtensor3 const& T, float4 const& v)
{
	return make_float3(
			T.xx*v.x + T.xy*v.y + T.xz*v.z,
			T.xy*v.y + T.yy*v.y + T.yz*v.z,
			T.xz*v.x + T.yz*v.y + T.zz*v.z);

}

#undef __spec
