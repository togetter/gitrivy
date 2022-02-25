<h2>{{- escapeXML ( index . 0 ).Target }} - Trivy Report</h2>
<table>
{{- range . }}
  <tr class="group-header"><th colspan="6">{{ escapeXML .Type }}</th></tr>
  <tr class="sub-header">
    <th>Package</th>
    <th>Vulnerability ID</th>
    <th>Severity</th>
    <th>Installed Version</th>
    <th>Fixed Version</th>
    <th>Links</th>
  </tr>
    {{- range .Vulnerabilities }}
  <tr class="severity-{{ escapeXML .Vulnerability.Severity }}">
    <td class="pkg-name">{{ escapeXML .PkgName }}</td>
    <td>{{ escapeXML .VulnerabilityID }}</td>
    <td class="severity">{{ escapeXML .Vulnerability.Severity }}</td>
    <td class="pkg-version">{{ escapeXML .InstalledVersion }}</td>
    <td>{{ escapeXML .FixedVersion }}</td>
    <td class="links" data-more-links="off">
      {{- range .Vulnerability.References }}
      <a href={{ escapeXML . | printf "%q" }}>{{ escapeXML . }}</a>
      {{- end }}
    </td>
  </tr>
  {{- end }}
{{- end }}
</table>