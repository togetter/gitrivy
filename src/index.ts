import * as core from '@actions/core';
import { Octokit } from '@octokit/rest';
import { Downloader } from './downloader';
import { GitHub } from './github';
import { Inputs } from './inputs';
import { scan } from './trivy';

async function run(): Promise<void> {
  const inputs = new Inputs();
  inputs.validate();

  const octokit = new Octokit({ auth: inputs.token });

  const downloader = new Downloader(octokit);
  const trivyCmdPath = await downloader.download(inputs.trivy.version);
  const result = scan(trivyCmdPath, inputs.image, inputs.trivy.option);

  if (!result) {
    return;
  }

  const github = new GitHub(octokit);
  const issueOption = { body: result, ...inputs.issue };
  const output = await github.createOrUpdateIssue(inputs.image, issueOption);

  core.setOutput('html_url', output.htmlUrl);
  core.setOutput('issue_number', output.issueNumber.toString());

  if (inputs.fail_on_vulnerabilities) {
    throw new Error('Abnormal termination because vulnerabilities found');
  }
}

run().catch(err => core.setFailed(err.message));
