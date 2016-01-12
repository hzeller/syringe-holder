syringe-holder.stl: bezier.dxf

%.eps: %.svg
	inkscape -E $@ $<

%.dxf: %.eps
	pstoedit -psarg "-r300x300" -dt -f dxf:"-polyaslines -mm" $< $@

%.stl: %.scad
	openscad -o $@ -d $@.deps $<
