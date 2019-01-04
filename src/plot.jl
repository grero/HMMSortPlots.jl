using Makie
using Colors
using AbstractPlotting
using MAT

function plot_sorting(mlseq::Matrix{T}, spikeforms::Matrix{T2}, data::Vector{T3};fs=30_000, timestep=0.1) where T <: Integer where T2 <: Real where T3 <: Real
    ntemplates = size(spikeforms,2)
    #find minimum point
    peak_state = permutedims([k[1] for k in argmax(abs.(spikeforms), dims=1)], [2,1])

    template_colors = distinguishable_colors(ntemplates, parse.(Colorant, ["deepskyblue","tomato"]))
    t = range(0.0, step=timestep, stop=(size(mlseq,2)-1)/fs)
    s1,a = AbstractPlotting.textslider(t, "t0", start=first(t))
    s2,b = AbstractPlotting.textslider(range(timestep, step=timestep/10,stop=1.0), "window", start=timestep)
    scene = Scene()
    ll = lines!(scene, [0.0], [0.0],color=:red)
    ll2 = lines!(scene, [0.0], [0.0])
    pts = scatter!(scene, [0.0], [0.0],markersize=1.0)
    map(scene.events.mousebuttons) do buttons
        if ispressed(scene, Mouse.left)
            pos = to_world(scene, Point2f0(scene.events.mouseposition[]))
            if first(t) <= pos[1] <= last(t)
                push!(s1[end][:value], pos[1])
            end
        end
    end
    map(s1[end][:value],s2[end][:value]) do _ss1, _ss2
        idx1 = round(Int64,_ss1*fs+1)
        idx2 = idx1 + round(Int64,_ss2*fs)
        if idx2 <= size(mlseq,2)
            Y = fill(0.0, idx2-idx1+1)
            kk = findall(mlseq[:,idx1:idx2] .== peak_state)
            _pts = [Point2f0(_ss1 + _kk[2]/fs, hdata[idx1+_kk[2]-1]) for _kk in kk]
            _colors = [template_colors[_kk[1]] for _kk in kk]
            for (i,ii) in enumerate(idx1:idx2)
                for j in 1:size(spikeforms,2)
                    if 0 < mlseq[j,ii] < size(spikeforms,1)
                        Y[i] += spikeforms[mlseq[j,ii],j]
                    end
                end
            end
            push!(scene.plots[2][1],[Point2f0(x,y) for (x,y) in zip(range(_ss1,stop=_ss1+_ss2, length=length(Y)), Y)])
            push!(scene.plots[3][1],[Point2f0(x,y) for (x,y) in zip(range(_ss1,stop=_ss1+_ss2, length=length(Y)), data[idx1:idx2])])
            push!(scene.plots[4][1], _pts)
            push!(scene.plots[4][:color], _colors)
            AbstractPlotting.update_limits!(scene)
            AbstractPlotting.update!(scene)
        end
    end 
    hbox(vbox(s1,s2),scene)
end

