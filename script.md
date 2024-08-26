# Aug 24 Dast Days - Unicorn Led Topic

Dast to the Future

DAST scanning helps identify security vulnerabilities in running applications, simulating real-world attacks.
By actively testing the application from an external perspective, DAST can uncover issues such as SQL injection, cross-site scripting (XSS), and other security flaws that could be exploited by malicious actors. 

Leveraging UDS we can have local and ci agnostic DAST jobs to give you a proactive approach to assessing these common expoloits so you can hopefully fix them before you have to pay for credit monitoring.

We have made DAST scanning your app, or exposed mission app easier than ever. All you need is a package manifest that exposes you service and uds and these task will do the rest. 

You'll want to follow the readme in the repo for the prereqs (uds, docker, k3d, that exposed service in your zarf package).

Say you are an engineer that has a zarf package that you've been working on for your app, you've been sure to include a manifest exposing some endpoint. If you want a DAST scan, it's as simple as:

- Deploy and Scan a local zarf package
    - `uds run dast-scan-package --set ZARF_PKG_PATH=<path-to-pkg>`
- Deploy and scan a zarf package from OCI
    - `uds run dast-scan-package --set ZARF_PKG_PATH=oci://<oci_path>`

Suppose your on the UDS team and some government rep is bugging you about performing DAST scans for your platform's core services, well dast-scan-everything might strike your fancy...

If you just want to scan any know endpoint in your cluster run: 
- `uds run dast-scan-everything`

The dast scan task can be easily modified to provide your report format of choice, we initial export json, html and markdown formats. 

In CI you can easily fail the job based on the severity of the findings. 
- To list total of high severity findings `grep -i -m 1 '| High |' podinfo.uds.dev-report.md |  awk -F'|' '{print $3}' `
- to list total medium severity findings `grep -i -m 1 '| Medium |' podinfo.uds.dev-report.md |  awk -F'|' '{print $3}'`  




 














- :watch:
- :office: :car::fire::fire::fire: