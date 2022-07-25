Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7768757FA7C
	for <lists+linux-xfs@lfdr.de>; Mon, 25 Jul 2022 09:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiGYHwv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 25 Jul 2022 03:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiGYHwu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jul 2022 03:52:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78815A189
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jul 2022 00:52:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AB73B80DFD
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jul 2022 07:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92E6C341C6;
        Mon, 25 Jul 2022 07:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658735566;
        bh=3eQLxx0dCuHX0at7LZUYpey7vCfSKdX9R8sOQFAPHTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pwa6dYaB8SCTfrBi18Efzq/KRyKX1pxZdz7XUuY8AvFXRNLAxD5pKwXwtXncgxAuE
         yzWun+yt1mYTCjjpOnD3Ovh/evVKGYbzdnMOnC61RGVobkxG2U+1vTDf1g8jtF8FZ6
         cYPhgiP29TGOQAU/qXSEpajhCzIo43KkuyjXZHkCBaPghpel4tquI9/IAX+kXdOMWy
         3N+ez6GNUJCjC3UBUVJLpuND84Lags7tt8cBpUMWaIBErQtxTqFt9kWYhDLpe2onlZ
         HbMe1OESKveU+h8k+0IoAQBjYiGzIagmxmldus/vi07AUjW748YAr3q3FkLILGueeG
         jdScNDqDiudiw==
Date:   Mon, 25 Jul 2022 09:52:42 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] mkfs: stop allowing tiny filesystems
Message-ID: <20220725075242.fhlgz6yzvxoociro@orion>
References: <165826709801.3268874.7256134380224140720.stgit@magnolia>
 <zp99XUB2wYiExiqwxsoxpoOrav6U7OOb0rFWHuvwSAWcwecFOaLf7NZOLeQ2paCJ2JaXmNWkoYUF8Tpplp6ZtA==@protonmail.internalid>
 <165826710918.3268874.7904878185632986856.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165826710918.3268874.7904878185632986856.stgit@magnolia>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 68d6bd18..9dd0e79c 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -859,6 +859,7 @@ struct cli_params {
>  	int64_t	logagno;
>  	int	loginternal;
>  	int	lsunit;
> +	int	is_supported;
> 
>  	/* parameters where 0 is not a valid value */
>  	int64_t	agcount;
> @@ -2496,6 +2497,68 @@ _("illegal CoW extent size hint %lld, must be less than %u.\n"),
>  	}
>  }
> 
> +/* Complain if this filesystem is not a supported configuration. */
> +static void
> +validate_supported(
> +	struct xfs_mount	*mp,
> +	struct cli_params	*cli)
> +{
> +	/* Undocumented option to enable unsupported tiny filesystems. */
> +	if (!cli->is_supported) {
> +		printf(
> + _("Filesystems formatted with --unsupported are not supported!!\n"));
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
> +
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
> +
> +	/*
> +	 * Filesystems should not have fewer than two AGs, because we need to
> +	 * have redundant superblocks.
> +	 */
> +	if (mp->m_sb.sb_agcount < 2) {
> +		fprintf(stderr,
> + _("Filesystem must have at least 2 superblocks for redundancy!\n"));
> +		usage();
> +	}
> +}
> +
>  /*
>   * Validate the configured stripe geometry, or is none is specified, pull
>   * the configuration from the underlying device.
> @@ -3966,9 +4029,21 @@ main(
>  	struct cli_params	cli = {
>  		.xi = &xi,
>  		.loginternal = 1,
> +		.is_supported	= 1,
>  	};
>  	struct mkfs_params	cfg = {};
> 
> +	struct option		long_options[] = {
> +	{
> +		.name		= "unsupported",
> +		.has_arg	= no_argument,
> +		.flag		= &cli.is_supported,
> +		.val		= 0,
> +	},
> +	{NULL, 0, NULL, 0 },
> +	};
> +	int			option_index = 0;
> +
>  	/* build time defaults */
>  	struct mkfs_default_params	dft = {
>  		.source = _("package build definitions"),
> @@ -4028,8 +4103,11 @@ main(
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
> @@ -4167,6 +4245,8 @@ main(
>  	validate_extsize_hint(mp, &cli);
>  	validate_cowextsize_hint(mp, &cli);
> 
> +	validate_supported(mp, &cli);
> +
>  	/* Print the intended geometry of the fs. */
>  	if (!quiet || dry_run) {
>  		struct xfs_fsop_geom	geo;
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos Maiolino
