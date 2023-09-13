#!/usr/bin/perl
use AnyEvent::HTTPD;
 
my $httpd = AnyEvent::HTTPD->new (port => 9090);
my $hostname = qx(hostname);

sub gather {
	my $summary = qx(vnstat -i eth0);
	my $monthly = qx(/usr/bin/vnstat -m);
	my $daily = qx(/usr/bin/vnstat -d);
	my $hourly = qx(/usr/bin/vnstat -h);

	my $template = <<END;
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>vnstat - $hostname</title>
</head>
<body>
	<h1>Host: $hostname</h1><hr>
	<h1>Summary:</h1><pre><code>$summary</code></pre><hr>
	<h1>Monthly:</h1><pre><code>$monthly</code></pre><hr>
	<h1>Daily:</h1><pre><code>$daily</code></pre><hr>
	<h1>Hourly:</h1><pre><code>$hourly</code></pre>
</body>
</html>
END
	return $template;
}

$httpd->reg_cb (
   '/' => sub {
      my ($httpd, $req) = @_;
      $req->respond ({ content => [ 'text/html', gather() ] });
   }
);
 
$httpd->run;
