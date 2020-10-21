
using ReadWriteDlm2
path="/Users/phenix/Documents/Cherish/Sprint_3/Localization_Wall/p_20_local_wall_open_p2/"
#Open
#shift=3
shift=0
cd(path*"Open/raw/")
println(pwd())
#=
for (root, dirs, files) in walkdir(path*"Open/raw")
    mkdir("renamed")
    println("Files in $root")
    g=["New_Name"]
    h=["Old_Name"]
    for file in files
        if file[(end-3):end]==".wav"
            println(file[44:(end-4)])
            println(joinpath(root, file)) # path to files
            println(joinpath(root, "renamed/"*file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]*".wav")) # path to files
            cp(joinpath(root, file),joinpath(root, "renamed/"*file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]*".wav"))
            g=vcat(g,[file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]])
            h=vcat(h,file[1:(end-4)])
        else

        end
        writecsv2("new_names.csv",hcat(g,h))
    end


end

cd(path*"Open/three_channels/")
for (root, dirs, files) in walkdir(path*"Open/three_channels")
    mkdir("renamed")
    println("Files in $root")
    g=["New_Name"]
    h=["Old_Name"]
    for file in files
        if file[(end-3):end]==".wav"
            println(file[44:(end-4)])
            println(joinpath(root, file)) # path to files
            println(joinpath(root, "renamed/"*file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]*".wav")) # path to files
            cp(joinpath(root, file),joinpath(root, "renamed/"*file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]*".wav"))
            g=vcat(g,[file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]])
            h=vcat(h,file[1:(end-4)])
        else

        end
        writecsv2("new_names.csv",hcat(g,h))
    end


end

#Closed
cd(path*"Closed/raw/")
for (root, dirs, files) in walkdir(path*"Closed/raw")
    mkdir("renamed")
    println("Files in $root")
    g=["New_Name"]
    h=["Old_Name"]
    for file in files
        if file[(end-3):end]==".wav"
            println(file[44:(end-4)])
            println(joinpath(root, file)) # path to files
            println(joinpath(root, "renamed/"*file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]*".wav")) # path to files
            cp(joinpath(root, file),joinpath(root, "renamed/"*file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]*".wav"))
            g=vcat(g,[file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]])
            h=vcat(h,file[1:(end-4)])
        else

        end
        writecsv2("new_names.csv",hcat(g,h))
    end


end

    writecsv2("new_names.csv",hcat(g,h))
end

cd(path*"Closed/three_channels/")
for (root, dirs, files) in walkdir(path*"Closed/three_channels")
    mkdir("renamed")
    println("Files in $root")
    g=["New_Name"]
    h=["Old_Name"]
    for file in files
        if file[(end-3):end]==".wav"
            println(file[44:(end-4)])
            println(joinpath(root, file)) # path to files
            println(joinpath(root, "renamed/"*file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]*".wav")) # path to files
            cp(joinpath(root, file),joinpath(root, "renamed/"*file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]*".wav"))
            g=vcat(g,[file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]])
            h=vcat(h,file[1:(end-4)])
        else

        end
        writecsv2("new_names.csv",hcat(g,h))
    end


end

#Normal

cd(path*"Normal/raw/")
for (root, dirs, files) in walkdir(path*"Normal/raw")
    mkdir("renamed")
    println("Files in $root")
    g=["New_Name"]
    h=["Old_Name"]
    for file in files
        if file[(end-3):end]==".wav"
            println(file[44:(end-4)])
            println(joinpath(root, file)) # path to files
            println(joinpath(root, "renamed/"*file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]*".wav")) # path to files
            cp(joinpath(root, file),joinpath(root, "renamed/"*file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]*".wav"))
            g=vcat(g,[file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]])
            h=vcat(h,file[1:(end-4)])
        else

        end
        writecsv2("new_names.csv",hcat(g,h))
    end


end

cd(path*"Normal/three_channels/")
for (root, dirs, files) in walkdir(path*"Normal/three_channels")
    mkdir("renamed")
    println("Files in $root")
    g=["New_Name"]
    h=["Old_Name"]
    for file in files
        if file[(end-3):end]==".wav"
            println(file[44:(end-4)])
            println(joinpath(root, file)) # path to files
            println(joinpath(root, "renamed/"*file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]*".wav")) # path to files
            cp(joinpath(root, file),joinpath(root, "renamed/"*file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]*".wav"))
            g=vcat(g,[file[1:42]*string(hash(hex2bytes(file[45:(end-4)])))[(4+shift):(6+shift)]])
            h=vcat(h,file[1:(end-4)])
        else

        end
        writecsv2("new_names.csv",hcat(g,h))
    end


end
=#
