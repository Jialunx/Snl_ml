ww3_input_file = ['/home/jialun/keydoc/ww3_fortran/WW3_new/regtests/ww3_ts1_test/input/ww3_strt.inp'];
output_folder = '/home/jialun/keydoc/ww3_output/outputfolder';
output_folder3 = '/home/jialun/keydoc/ww3_output/outputfolder3'; % (name end with 3 is DIA output at each integration step)
bash = 'bash run-test-generic1_test_new.sh';
bash3 = 'bash run-test-generic1_test_new3.sh';
rmdir('/home/jialun/keydoc/ww3_fortran/WW3_new/regtests/ww3_ts1_test/temp','s')
rmdir('/home/jialun/keydoc/ww3_fortran/WW3_new3/regtests/ww3_ts1_test/temp','s')

function write_snl_ml_to_file(S_nl_ml, filename)
writematrix(S_nl_ml, filename, 'Delimiter', ' ');
end

%% run ml integration 
start_time = datetime('1968-06-06 00:00:00', 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
stop_time  = datetime('1968-06-06 00:01:00', 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
start_time3 = datetime('1968-06-06 00:00:00', 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
stop_time3  = datetime('1968-06-06 00:01:00', 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
filename = '/home/jialun/keydoc/ww3_fortran/WW3_new/regtests/ww3_ts1_test/input/ww3_shel.nml';
filename3 = '/home/jialun/keydoc/ww3_fortran/WW3_new3/regtests/ww3_ts1_test/input/ww3_shel.nml';

for i =  1:2881
    start_str = datestr(start_time, 'yyyymmdd HHMMSS');
    stop_str  = datestr(stop_time, 'yyyymmdd HHMMSS');
    start_str3 = datestr(start_time3, 'yyyymmdd HHMMSS');
    stop_str3  = datestr(stop_time3, 'yyyymmdd HHMMSS');
    fileText = fileread(filename);
    fileText3 = fileread(filename3);

    updatedText = regexprep(fileText, ...
        'DOMAIN%START\s*=\s*''\d{8} \d{6}''', ...
        sprintf("DOMAIN%%START    = '%s'", start_str));
    updatedText = regexprep(updatedText, ...
        'DOMAIN%STOP\s*=\s*''\d{8} \d{6}''', ...
        sprintf("DOMAIN%%STOP    = '%s'", stop_str));
    updatedText3 = regexprep(fileText3, ...
        'DOMAIN%START\s*=\s*''\d{8} \d{6}''', ...
        sprintf("DOMAIN%%START    = '%s'", start_str3));
    updatedText3 = regexprep(updatedText3, ...
        'DOMAIN%STOP\s*=\s*''\d{8} \d{6}''', ...
        sprintf("DOMAIN%%STOP    = '%s'", stop_str3));

    updatedText = regexprep(updatedText, ...
        'DATE%FIELD\s+=\s+''\d{8} \d{6}''\s+''\d+''\s+''\d{8} \d{6}''', ...
        sprintf("DATE%%FIELD          = '%s' '60' '%s'", start_str, stop_str));
    updatedText = regexprep(updatedText, ...
        'DATE%POINT\s+=\s+''\d{8} \d{6}''\s+''\d+''\s+''\d{8} \d{6}''', ...
        sprintf("DATE%%POINT          = '%s' '60' '%s'", start_str, stop_str));
    updatedText3 = regexprep(updatedText3, ...
        'DATE%FIELD\s+=\s+''\d{8} \d{6}''\s+''\d+''\s+''\d{8} \d{6}''', ...
        sprintf("DATE%%FIELD          = '%s' '60' '%s'", start_str3, stop_str3));
    updatedText3 = regexprep(updatedText3, ...
        'DATE%POINT\s+=\s+''\d{8} \d{6}''\s+''\d+''\s+''\d{8} \d{6}''', ...
        sprintf("DATE%%POINT          = '%s' '60' '%s'", start_str3, stop_str3));

    fid = fopen(filename, 'w');
    fprintf(fid, '%s', updatedText);
    fclose(fid);

    fid3 = fopen(filename3, 'w');
    fprintf(fid3, '%s', updatedText3);
    fclose(fid3);

    start_time = start_time+ seconds(60);
    stop_time  = stop_time + seconds(60);

    start_time3 = start_time3+ seconds(60) ;
    stop_time3  = stop_time3 + seconds(60);

    if i == 1
        file1 = '/home/jialun/keydoc/ww3_output/ww3_new2_output/ww3.1968_src.nc';%initial spectrum
        efth = ncread(file1,'efth');
        wave_data = efth(:,:,1,1);
    else
        filex = sprintf('/home/jialun/keydoc/ww3_output/outputfolder/wave_output_set_%d.nc', i-1);
        efth = ncread(filex,'efth');
        wave_data = efth(:,:,1,2);

        fid = fopen(ww3_input_file, 'w');
        fprintf(fid, 'Wave data for set %d\n', i);
        fprintf(fid, '\n');
        fprintf(fid, '\n');
        fprintf(fid, '4\n');
        fprintf(fid, '1\n');
        for dir = 1:24
            for freq = 1:40
                fprintf(fid, '%f ', wave_data(dir, freq));
            end
            fprintf(fid, '\n');
        end
        fclose(fid);

        fid3 = fopen(ww3_input_file3, 'w');
        fprintf(fid3, 'Wave data for set %d\n', i);
        fprintf(fid3, '\n');
        fprintf(fid3, '\n');
        fprintf(fid3, '4\n');
        fprintf(fid3, '1\n');
        for dir = 1:24
            for freq = 1:40
                fprintf(fid3, '%f ', wave_data(dir, freq));
            end
            fprintf(fid3, '\n');
        end
        fclose(fid3);
    end

    cd('/home/jialun/keydoc/ww3_fortran/')
    system(bash3);

    output_nc_file3 = fullfile('/home/jialun/keydoc/ww3_fortran/WW3_new3/regtests/ww3_ts1_test/temp/', 'ww3.196806_src.nc');
    output_nc_file32 = fullfile('/home/jialun/keydoc/ww3_fortran/WW3_new3/regtests/ww3_ts1_test/temp/', 'ww3.196806.nc');
    copyfile(output_nc_file3, fullfile(output_folder3, sprintf('wave_output_set_%d.nc', i)));
    copyfile(output_nc_file32, fullfile(output_folder_spr3, sprintf('wave_output_set_spr_%d.nc', i)));

    spec = squeeze(wave_data);
    filex1 = sprintf('/home/jialun/keydoc/ww3_output/outputfolder3/wave_output_set_%d.nc', i);
    Snl_dia = ncread(filex1,'snl');
    Snl_dia = Snl_dia(:,:,1);

    src3 = spec/ max(spec(:));
    Input = src3(:);
    snl_N = Snl_dia/max(abs(Snl_dia(:)));
    Output = snl_N(:);

    Input = Input(1:end,:);
    Output = Output(1:end,:);

    filename1 = "/home/jialun/keydoc/ww3_python/pyfiles/input_test.csv";
    filename2 = "/home/jialun/keydoc/ww3_python/pyfiles/input_dia_test.csv";
    csvwrite(filename1,Input')
    csvwrite(filename2,Output')

    scriptPath = '/home/jialun/keydoc/ww3_python/snl.py';
    pyenv('Version', '/home/jialun/.venv/bin/python3');
    pyrunfile(scriptPath);
    pred = load('/home/jialun/keydoc/ww3_python/pyfiles/pred.csv');
    predn = pred*max(abs(Snl_dia(:)));
    S_nl_ml = predn(:);

    filenamexx = sprintf('/home/jialun/keydoc/ww3_python/snl_ml_results/snl_ml_results_%d.txt', i);
    write_snl_ml_to_file(S_nl_ml, filenamexx);
    input_filename = sprintf('/home/jialun/keydoc/ww3_python/snl_ml_results/snl_ml_results_%d.txt', i);
    data = load(input_filename);
    output_filename = '/home/jialun/keydoc/ww3_python/snl_ml_results/snl_ml_results.txt';
    fid_out = fopen(output_filename, 'w');
    fprintf(fid_out, '%.16e\n', data);

    cd('/home/jialun/keydoc/ww3_fortran/')
    system(bash);

    output_nc_file = fullfile('/home/jialun/keydoc/ww3_fortran/WW3_new/regtests/ww3_ts1_test/temp/', 'ww3.196806_src.nc'); % Modify this if output filename is different
    output_nc_file2 = fullfile('/home/jialun/keydoc/ww3_fortran/WW3_new/regtests/ww3_ts1_test/temp/', 'ww3.196806.nc');
    copyfile(output_nc_file, fullfile(output_folder, sprintf('wave_output_set_%d.nc', i)));
    copyfile(output_nc_file2, fullfile(output_folder_spr, sprintf('wave_output_set_spr_%d.nc', i)));
end

disp('All sets processed successfully.');
















