function [out,num_users,is_host_up] = get_unix_host_logged_in_users(host_url)

is_host_up = is_ssh_host_responding2(host_url);

if(is_host_up)


    string_args = {'ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 ',host_url,'"who | grep -oP ''^[^ ]+''  ;echo ENDSSH"'};
    cmd =  [ld_lib_path_fix build_string_args(string_args)];
    [~,stdout] =system(cmd);
    stdout_lines = filter_empty_strings( strsplit(stdout,'\n') );
    out = filter_string_list(stdout_lines,'ENDSSH',1);
    out = filter_string_list(out,'failed to connect to server',1);
    out = filter_string_list(out,'Warning: Permanently added',1);
    out = filter_string_list(out,'RESOURCE-INTENSIVE',1);
    out = filter_string_list(out,'known hosts',1);
    out = filter_string_list(out,'WARNING : Unauthorized access',1);
    out = filter_string_list(out,'prosecuted by law. By accessing',1);
    out = filter_string_list(out,'may be monitored',1);
    out = filter_string_list(out,'pts',0);
    out = filter_string_list(out,'tty',0);


    num_users = length(out);
    
else
    fprintf('%s is unresponsive. \n', host_url)
    out={};
    num_users = Inf;
end