function ganttchart(; x::AbstractVector = [], y::AbstractVector = [], group::AbstractVector = [])

    v = VegaVisualization()
    table = "gantt_" * lowercase(randstring(10))

    n = length(x)
    if n != length(y) || (n != length(group) && length(group) != 0)
    	error("x, y and group must all have the same length")
    end
    _group = isempty(group)? ones(Int, n): group

    values = [Dict(
                "y" => y,
                "x"=>x[1],
                "x2"=>x[2],
                "group"=>g,
            ) for (x,y,g) in zip(x,y,_group)]

    #add_data!(v, x=t0, y=y, group=group)
    v.data = [VegaData(name=table, values=values)]

    if length(group) > 0
        legend!(v)
    end

    default_scales!(v; typeYaxis="ordinal")
    v.scales[1].domain.field = ["x", "x2"]
    v.scales[2].points = true
    v.scales[2].padding = 1

    default_axes!(v)
    v.axes[2].grid=true

    res = VegaMark(_type = "rect",
                  from = VegaMarkFrom(data=table),
                  properties = VegaMarkProperties(
                      enter = VegaMarkPropertySet(
                          x = VegaValueRef(scale = "x", field = "x"),
                          x2 = VegaValueRef(scale = "x", field = "x2"),
                          yc = VegaValueRef(scale = "y", field = "y"),
                          opacity = VegaValueRef(value=0.5)
                      ),
                  )
              )

    v.marks == nothing? v.marks = [res] : push!(v.marks, res)

    v.marks[1].properties.enter.y =
        VegaValueRef(scale = "y", field = "y")

    v.marks[1].properties.enter.height =
        VegaValueRef(value=1, scale="y")

    v.marks[1].properties.enter.fill =
        VegaValueRef(scale = "group", field = "group")

    return v
end
