Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD4F70E351
	for <lists+linux-xfs@lfdr.de>; Tue, 23 May 2023 19:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238217AbjEWRk4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 May 2023 13:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238124AbjEWRkz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 13:40:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E13797
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 10:40:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE81262CC9
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 17:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14029C433EF;
        Tue, 23 May 2023 17:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684863654;
        bh=F7p6KyyGHzQ/TzTak4882arF+9gsyZa0dbd0TBIpCyI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m/U90V/2lU0MnOJa9PEn2v2/JyL9m9U4QjsOfdvJUk8A6BDMuu3vmxUS+5J5LrnCv
         jDNn1BnwVGeGl0CVgardqcKTtGf9IgBYwRS5oATfFW0iIFLvVcWs4PGE1ZqTqq7JjN
         nWiKg+xhAuavZlUb6xK87N197GymmBf31vGcEVY1uejpb3whd7wG55AX23yOhkclQG
         18x0tfwPkZsaFBrPmZDbM8JuzyLCysTGtdRvOH+qkrNULaunc9AuUw6Q/eY9UGgyZu
         YG3EUNHIMI3khhPqclF+SRJhOf6A/IMpmvXg7vg/1KzpKFJfuDsnROF/2GfFyHxg+r
         wRLMm/V53kfzQ==
Date:   Tue, 23 May 2023 10:40:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/24] xfs_metadump.8: Add description for the newly
 introduced -v option
Message-ID: <20230523174053.GU11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-16-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-16-chandan.babu@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:41PM +0530, Chandan Babu R wrote:
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

This should be in the previous patch.

> ---
>  man/man8/xfs_metadump.8 | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
> index c0e79d779..23695c768 100644
> --- a/man/man8/xfs_metadump.8
> +++ b/man/man8/xfs_metadump.8
> @@ -11,6 +11,9 @@ xfs_metadump \- copy XFS filesystem metadata to a file
>  ] [
>  .B \-l
>  .I logdev
> +] [
> +.B \-v
> +.I version
>  ]
>  .I source
>  .I target
> @@ -74,6 +77,9 @@ metadata such as filenames is not considered sensitive.  If obfuscation
>  is required on a metadump with a dirty log, please inform the recipient
>  of the metadump image about this situation.
>  .PP
> +The contents of an external log device can be dumped only when using the v2
> +format. Metadump in v2 format can be generated by passing the "-v 2" option.

Please start each sentence on a separate line.

This also should mention that metadump will pick v2 if there's no
explicit -v option and the fs has an external log.

--D

> +.PP
>  .B xfs_metadump
>  should not be used for any purposes other than for debugging and reporting
>  filesystem problems. The most common usage scenario for this tool is when
> @@ -134,6 +140,10 @@ this value.  The default size is 2097151 blocks.
>  .B \-o
>  Disables obfuscation of file names and extended attributes.
>  .TP
> +.B \-v
> +The format of the metadump file to be produced. Valid values are 1 and 2. The
> +default metadump format is 1.
> +.TP
>  .B \-w
>  Prints warnings of inconsistent metadata encountered to stderr. Bad metadata
>  is still copied.
> -- 
> 2.39.1
> 
