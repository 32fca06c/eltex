// Предоставляется окружением
var role;
 
if (role != 'master' && role != 'slave') {
    throw "Role must be either master or slave";
}
 
var thisIsMaster = (role == 'master');
var status = rs.isMaster();
var thisHost = status.me;
 
print("Primary: " + status.ismaster + "; applying configuration ...");
var cfg = rs.conf();
for (var i = 0; i < cfg.members.length; i++) {
    var member = cfg.members[i];
    var self = (member.host == thisHost);
    if (self ^ thisIsMaster) {
        // Конфигурация для slave
        member.priority = 1;
        member.votes = 0;
 
        print(member.host + ": secondary");
    } else {
        // Конфигурация для master
        member.priority = 2;
        member.votes = 1;
 
        print(member.host + ": primary");
    }
}
 
var result = rs.reconfig(cfg, { force: !status.ismaster });
if (result.ok == 1) {
    print("Reconfiguration done");
} else {
    print(result);
}