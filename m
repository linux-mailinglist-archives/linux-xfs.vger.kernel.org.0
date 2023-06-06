Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EBC72402A
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Jun 2023 12:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbjFFKzN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Jun 2023 06:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237022AbjFFKyN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 06:54:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE6E273F
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 03:50:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7D8061166
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 10:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883E6C433EF;
        Tue,  6 Jun 2023 10:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686048653;
        bh=leLJxy7Gct+L/EEmP11fqk+UZ13GPaP4FqvmQDGeGjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L0GCbeyCazBrymlUb6GM8LDUuRglB6qjE9ns+cWxbkqHn2w6FAWalMvjJ4zkF6gKZ
         skCDWzazMY2cHLSZnX4NWvi3QS0BlPe8zNFPjRUA9z6F90IiV6pDU999yQxIAvuGqI
         4ia53t38kkd0FBSWj4vlwGsa/apjKEbR0/X9x3xHZTmySWLY2zRntOVb2iyzWd9uSg
         tLOUfgYXHHJhMRBYbF/0E/M+UK4vBtrd3m5ib9rEWRGs1Cu+mG0IPWJbv38izexeRB
         /G5ugVEaba9OmjQTuf2MqOTqWUfpNfTaPiJUDnrd3TEmJFMIqOJ/ONKDMJZ/wPllbb
         Q7+ga3X9EChcQ==
Date:   Tue, 6 Jun 2023 12:50:49 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_repair: don't spray correcting imap all by itself
Message-ID: <20230606105049.ci2lrb72hlpegxun@andromeda>
References: <168597945354.1226461.5438962607608083851.stgit@frogsfrogsfrogs>
 <pK1ivF30Db3pHJXEnAiIiQtckJDg6ssGbk7EBFkWY9CzOLoXaC4kaOlwpVjNcU55XQAOkWJFbhgjtpCmTz8o3Q==@protonmail.internalid>
 <168597945921.1226461.946607316221373794.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168597945921.1226461.946607316221373794.stgit@frogsfrogsfrogs>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 08:37:39AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In xfs/155, I occasionally see this in the xfs_repair output:
> 
> correcting imap
> correcting imap
> correcting imap
> ...
> 
> This is completely useless, since we don't actually log which inode
> prompted this message.  This logic has been here for a really long time,
> but ... I can't make heads nor tails of it.  If we're running in verbose
> or dry-run mode, then print the inode number, but not if we're running
> in fixit mode?
> 
> A few lines later, if we're running in verbose dry-run mode, we print
> "correcting imap" even though we're not going to write anything.
> 
> If we get here, the inode looks like it's in use, but the inode index
> says it isn't.  This is a corruption, so either we fix it or we say that
> we would fix it.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> 
> Fixes: 6c39a3cbda3 ("Don't trash lost+found in phase 4 Merge of master-melb:xfs-cmds:29144a by kenmcd.")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/dino_chunks.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
> index cf6a5e399d4..33008853789 100644
> --- a/repair/dino_chunks.c
> +++ b/repair/dino_chunks.c
> @@ -871,13 +871,11 @@ process_inode_chunk(
>  		 */
>  		if (is_used)  {
>  			if (is_inode_free(ino_rec, irec_offset))  {
> -				if (verbose || no_modify)  {
> -					do_warn(
> +				do_warn(
>  	_("imap claims in-use inode %" PRIu64 " is free, "),
>  						ino);
> -				}
> 
> -				if (verbose || !no_modify)
> +				if (!no_modify)
>  					do_warn(_("correcting imap\n"));
>  				else
>  					do_warn(_("would correct imap\n"));
> 
