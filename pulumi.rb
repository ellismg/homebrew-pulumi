class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  version "1.0.0-beta.1"
  url "https://get.pulumi.com/releases/sdk/pulumi-v1.0.0-beta.1-darwin-x64.tar.gz"
  sha256 "678e0ec39c57b0e251cec728874756241a4cc949ce354915edd70accf250e8d6"

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
