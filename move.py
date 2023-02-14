import os
import pathlib

exdir = "Ex"

for i in range(1,8):
    cur_dir = exdir + str(i)
    for file in os.listdir(cur_dir):
        name, suffix = file.split(".")
        if suffix == 'm':
            curent_path = pathlib.Path(__file__).parent.absolute()
            old_file_dir = os.path.join(curent_path, cur_dir,file)
            new_file_dir = os.path.join(curent_path, file)
            os.rename(old_file_dir, new_file_dir)
        
