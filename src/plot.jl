using Makie
using AbstractPlotting
using MAT

function plot_sorting(mlseq::Matrix{T}, spikeforms::Matrix{T2}, fs=30_000, timestep=0.1) where T <: Integer where T2 <: Real
    t = range(0.0, step=timestep, stop=(size(mlseq,2)-1)/fs)
    s1,a = AbstractPlotting.textslider(t, "t0", start=first(t))
    s2,b = AbstractPlotting.textslider(range(0.1, step=0.01,stop=1.0), "window", start=0.1)
    scene = Scene()
    ll = lines!(scene, [0.0], [0.0])
    map(s1[end][:value],s2[end][:value]) do _ss1, _ss2
        idx1 = round(Int64,_ss1*fs+1)
        idx2 = idx1 + round(Int64,_ss2*fs)
        if idx2 <= size(mlseq,2)
            Y = fill(0.0, idx2-idx1+1)
            for (i,ii) in enumerate(idx1:idx2)
                for j in 1:size(spikeforms,2)
                    if 0 < mlseq[j,ii] < size(spikeforms,1)
                        Y[i] += spikeforms[mlseq[j,ii],j]
                    end
                end
            end
            push!(scene.plots[2][1],[Point2f0(x,y) for (x,y) in zip(range(_ss1,stop=_ss1+_ss2, length=length(Y)), Y)])
            AbstractPlotting.update_limits!(scene)
            AbstractPlotting.update!(scene)
        end
    end 
    hbox(vbox(s1,s2),scene)
end

