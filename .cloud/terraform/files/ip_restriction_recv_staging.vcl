if (req.http.Fastly-Client-IP !~ ACL_to_access_preprod_6play_fr){
    error 666 "Forbidden";
}
