package io.jenkins.plugins.casc;

import static org.junit.Assert.assertFalse;

import io.jenkins.plugins.casc.misc.ConfiguredWithCode;
import io.jenkins.plugins.casc.misc.JenkinsConfiguredWithCodeRule;
import jenkins.model.Jenkins;
import org.junit.Rule;
import org.junit.Test;

public class UsageStatisticsTest {

    @Rule
    public JenkinsConfiguredWithCodeRule j = new JenkinsConfiguredWithCodeRule();

    @Test
    @ConfiguredWithCode("NoNoUsageStatistics.yml")
    public void configure_no_usage_statistics() throws Exception {
        final Jenkins jenkins = Jenkins.get();
        assertFalse(jenkins.isUsageStatisticsCollected());
    }

}
