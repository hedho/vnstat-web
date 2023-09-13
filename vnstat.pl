#!/usr/bin/perl
use AnyEvent::HTTPD;

my $httpd = AnyEvent::HTTPD->new (port => 9090);
my $hostname = qx(hostname);

sub gather {
	my $summary = qx(vnstat -i enp41s0);
	my $monthly = qx(/usr/bin/vnstat -m);
	my $daily = qx(/usr/bin/vnstat -d);
	my $hourly = qx(/usr/bin/vnstat -h);

	my $template = <<END;
<!DOCTYPE html>
<html lang="en">
<head>
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="HandheldFriendly" content="true">
    <meta charset="utf-8">
    <title>vnstat - $hostname</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f0f0;
            color: #333;
        }

        header {
            background-color: #0078d4;
            color: white;
            text-align: center;
            padding: 20px;
        }

        h1 {
            text-align: center;
            margin: 20px 0;
        }

        hr {
            border: 1px solid #ccc;
        }

        pre {
            background-color: #f8f8f8;
            padding: 10px;
            border-radius: 5px;
            overflow: auto;
        }

        code {
            font-family: Consolas, Monaco, monospace;
            background-color: #f1f1f1;
            padding: 2px 6px;
            border-radius: 3px;
            color: #333;
        }

        p {
            text-align: center;
            font-style: italic;
            color: #777;
        }
    </style>
</head>
<body>
    <header>
        <h1>vnstat - $hostname</h1>
    </header>
    <main>
	<pre>
<p><img alt="" src="https://x.4solution.no/vnstat.png" style="height:370px; width:500px" /></p>
<p><img alt="" src="https://x.4solution.no/summary.png" style="height:200px; width:500px" /><br />
<br />
<img alt="" src="https://x.4solution.no/network-log.png" style="height:134px; width:500px" /><br />
<br />
<img alt="" src="https://x.4soltuion.no/hour.png" /><img alt="" src="https://x.4solution.no/hour.png" style="height:398px; width:500px" /><br />
<br />
<img alt="" src="https://x.4solution.no/month.png" style="height:98px; width:500px" /></p><br />
</pre>
	</main>
    <footer>
        <p>This stats interface for any Unix/Linux-like system was developed by Arianit Kukaj</p>
    </footer>
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
