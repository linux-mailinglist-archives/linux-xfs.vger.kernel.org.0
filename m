Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1474C5740CE
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Jul 2022 03:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiGNBJ2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 Jul 2022 21:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiGNBJ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 21:09:27 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 806761FCD1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 18:09:26 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 59EB74435;
        Wed, 13 Jul 2022 20:09:04 -0500 (CDT)
Message-ID: <bbb444a9-1628-b98c-a5fb-947873272b15@sandeen.net>
Date:   Wed, 13 Jul 2022 20:09:24 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165644942559.1091646.1065506297333895934.stgit@magnolia>
 <165644943121.1091646.10171089108168615883.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/1] mkfs: stop allowing tiny filesystems
In-Reply-To: <165644943121.1091646.10171089108168615883.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/28/22 3:50 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Refuse to format a filesystem that are "too small", because these
> configurations are known to have performance and redundancy problems
> that are not present on the volume sizes that XFS is best at handling.
> 
> Specifically, this means that we won't allow logs smaller than 64MB, we
> won't allow single-AG filesystems, and we won't allow volumes smaller
> than 300MB.  There are two exceptions: the first is an undocumented CLI
> option that can be used for crafting debug filesystems.
> 
> The second exception is that if fstests is detected, because there are a
> lot of fstests that use tiny filesystems to perform targeted regression
> and functional testing in a controlled environment.  Fixing the ~40 or
> so tests to run more slowly with larger filesystems isn't worth the risk
> of breaking the tests.

This bugs me, because we're now explicitly testing filesystems that nobody
will be allowed to use in real life. Just seems odd. But so be it, I guess.
I understand why, it's just bleah.  If I care enough, I could try to whittle
away at those tests and remove this hack some day.

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mkfs/xfs_mkfs.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 81 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index db322b3a..728a001a 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -847,6 +847,7 @@ struct cli_params {
>  	int64_t	logagno;
>  	int	loginternal;
>  	int	lsunit;
> +	int	has_warranty;
>  
>  	/* parameters where 0 is not a valid value */
>  	int64_t	agcount;
> @@ -2484,6 +2485,68 @@ _("illegal CoW extent size hint %lld, must be less than %u.\n"),
>  	}
>  }
>  
> +/* Complain if this filesystem is not a supported configuration. */
> +static void
> +validate_warranty(
> +	struct xfs_mount	*mp,
> +	struct cli_params	*cli)
> +{
> +	/* Undocumented option to enable unsupported tiny filesystems. */
> +	if (!cli->has_warranty) {
> +		printf(
> + _("Filesystems formatted with --yes-i-know-what-i-am-doing are not supported!!\n"));

maybe we can just make this "--unsupported" to be concise and self-documenting.

> +		return;
> +	}
> +
> +	/*
> +	 * fstests has a large number of tests that create tiny filesystems to
> +	 * perform specific regression and resource depletion tests in a
> +	 * controlled environment.  Avoid breaking fstests by allowing
> +	 * unsupported configurations if TEST_DIR, TEST_DEV, and QA_CHECK_FS
> +	 * are all set.
> +	 */
> +	if (getenv("TEST_DIR") && getenv("TEST_DEV") && getenv("QA_CHECK_FS"))
> +		return;
> +
> +	/*
> +	 * We don't support filesystems smaller than 300MB anymore.  Tiny
> +	 * filesystems have never been XFS' design target.  This limit has been
> +	 * carefully calculated to prevent formatting with a log smaller than
> +	 * the "realistic" size.
> +	 *
> +	 * If the realistic log size is 64MB, there are four AGs, and the log
> +	 * AG should be at least 1/8 free after formatting, this gives us:
> +	 *
> +	 * 64MB * (8 / 7) * 4 = 293MB
> +	 */
> +	if (mp->m_sb.sb_dblocks < MEGABYTES(300, mp->m_sb.sb_blocklog)) {
> +		fprintf(stderr,
> + _("Filesystem must be larger than 300MB.\n"));
> +		usage();
> +	}
> +	/*
> +	 * For best performance, we don't allow unrealistically small logs.
> +	 * See the comment for XFS_MIN_REALISTIC_LOG_BLOCKS.
> +	 */
> +	if (mp->m_sb.sb_logblocks <
> +			XFS_MIN_REALISTIC_LOG_BLOCKS(mp->m_sb.sb_blocklog)) {
> +		fprintf(stderr,
> + _("Log size must be at least 64MB.\n"));
> +		usage();
> +	}

So in practice, on striped storage this will require the filesystem to be a
bit over 500M to satisfy this constraint.  I worry about this constraint a
little.

# mkfs.xfs -dfile,name=fsfile,size=510m,su=32k,sw=4
Log size must be at least 64MB.

<hapless user reads manpage, adjusts log size>

# mkfs.xfs -dfile,name=fsfile,size=510m,su=32k,sw=4 -l size=64m
internal log size 16384 too large, must be less than 16301

So the log must be both "at least 64MB" and also "less than 64MB"

In reality, the problem is the filesystem size on this type of storage,
not the log size.

Let me think more about this. I understand and agree with the goal, I want
to do it in a way that doesn't cause user confusion...

> +	/*
> +	 * Filesystems should not have fewer than two AGs, because we need to
> +	 * have redundant superblocks.
> +	 */
> +	if (mp->m_sb.sb_agcount < 2) {
> +		fprintf(stderr,
> + _("Filesystem must have redundant superblocks!\n"));

I think we should say "at least 2 AGs" because that's what can be directly
specified by the user. They won't know what it means to have redundant
supers.

> +		usage();	
> +	}
> +}
> +
>  /*
>   * Validate the configured stripe geometry, or is none is specified, pull
>   * the configuration from the underlying device.
> @@ -3933,9 +3996,21 @@ main(
>  	struct cli_params	cli = {
>  		.xi = &xi,
>  		.loginternal = 1,
> +		.has_warranty	= 1,
>  	};
>  	struct mkfs_params	cfg = {};
>  
> +	struct option		long_options[] = {
> +	{
> +		.name		= "yes-i-know-what-i-am-doing",
> +		.has_arg	= no_argument,
> +		.flag		= &cli.has_warranty,
> +		.val		= 0,
> +	},
> +	{NULL, 0, NULL, 0 },
> +	};
> +	int			option_index = 0;
> +
>  	/* build time defaults */
>  	struct mkfs_default_params	dft = {
>  		.source = _("package build definitions"),
> @@ -3995,8 +4070,11 @@ main(
>  	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
>  	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
>  
> -	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
> +	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
> +					long_options, &option_index)) != EOF) {
>  		switch (c) {
> +		case 0:
> +			break;
>  		case 'C':
>  		case 'f':
>  			force_overwrite = 1;
> @@ -4134,6 +4212,8 @@ main(
>  	validate_extsize_hint(mp, &cli);
>  	validate_cowextsize_hint(mp, &cli);
>  
> +	validate_warranty(mp, &cli);
> +
>  	/* Print the intended geometry of the fs. */
>  	if (!quiet || dry_run) {
>  		struct xfs_fsop_geom	geo;
> 
