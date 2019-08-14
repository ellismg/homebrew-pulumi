class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  version "1.0.0-beta.2"
  url "https://get.pulumi.com/releases/sdk/pulumi-v1.0.0-beta.2-darwin-x64.tar.gz"
  sha256 "e7e124d39cb9dd3f820b54c87399f15693c7fa7d3331c03a36a8eb505e959872"

  def install
    bin.install Dir["#{buildpath}/*"]
    prefix.install_metafiles

    # Install bash completion
    output = Utils.popen_read("#{bin}/pulumi gen-completion bash")
    (bash_completion/"pulumi").write output

    # Install zsh completion
    output = Utils.popen_read("#{bin}/pulumi gen-completion zsh")
    (zsh_completion/"_pulumi").write output
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
