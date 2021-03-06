#ifndef _STILLWATER_H
#define	_STILLWATER_H

#include "Problem.h"
#include "Point.h"
#include "Rect.h"
#include "Cube.h"

class StillWater: public Problem {
	private:
		Cube		experiment_box;
		PointVect	parts;
		PointVect	boundary_parts;
		PointVect	boundary_elems;
		PointVect	vertex_parts;
		VertexVect	vertex_indexes;

		float		h, w, l;
		float		H; // still water level
		bool		m_usePlanes; // use planes or boundaries

	public:
		StillWater(const GlobalData *);
		~StillWater(void);

		int fill_parts(void);
		uint fill_planes(void);
		void copy_to_array(BufferList &);
		void copy_planes(float4*, float*);

		void release_memory(void);
};


#endif	/* _STILLWATER_H */
