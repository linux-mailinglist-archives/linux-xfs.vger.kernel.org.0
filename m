Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF677BA079
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Oct 2023 16:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbjJEOiX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Oct 2023 10:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235901AbjJEOfx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 10:35:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCC6158FA
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 06:57:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B07C3279A;
        Thu,  5 Oct 2023 12:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696509455;
        bh=T5jOg8kM3KY40hMhaZWhJyH1j5s2diQbBvPMMbNu9qQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YP5SRJsDivpnrfnEa57e08CKvh2ZrRb2qlSB0I20vPlRdNutSgQ/6AeoKjbEMStCo
         kofRSbm6FpUEN3supblF9gy79f6AlJZ2v/8WyTzNatRdIIcxOLVXT+5NyHPc37T6ZS
         M/EDjBPZtapMHqpgvv2MDnAU7YwRWe6Ywn2hzWncCeTFvUwlzaZvAJ+v1blo6yAAGy
         Q7BowaUfmk+CrdUXDnGda/7aQr4RhLGkRiuOsyMnwjTu4W8BHrX+t0s3A9cISWDvdc
         7p9hx3LymTgIyYAKuWwDpeW4pk6z3TUvZskyw/+qpZssEV90TErVg7A/QuM1ee8KPZ
         Idksmehxhh0NA==
Date:   Thu, 5 Oct 2023 14:37:31 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs_repair: set aformat and anextents correctly when
 clearing the attr fork
Message-ID: <20231005123731.re3luz7nsyigkcmq@andromeda>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
 <w3T3skdhB6ig90SVQ8Q4MioBjk9lUH2K6uvsYLKKEgAf89O2SctP_G3ECpSBT-EI2W4cKWp3xmv-Mo-AaD3IyA==@protonmail.internalid>
 <169454760445.3539425.1849980383287926875.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169454760445.3539425.1849980383287926875.stgit@frogsfrogsfrogs>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:40:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Ever since commit b42db0860e130 ("xfs: enhance dinode verifier"), we've
> required that inodes with zero di_forkoff must also have di_aformat ==
> EXTENTS and di_naextents == 0.  clear_dinode_attr actually does this,
> but then both callers inexplicably set di_format = LOCAL.  That in turn
> causes a verifier failure the next time the xattrs of that file are
> read by the kernel.  Get rid of the bogus field write.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Carlos

> ---
>  repair/dinode.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index e534a01b500..c10dd1fa322 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2078,7 +2078,6 @@ process_inode_attr_fork(
>  		if (!no_modify)  {
>  			do_warn(_(", clearing attr fork\n"));
>  			*dirty += clear_dinode_attr(mp, dino, lino);
> -			dino->di_aformat = XFS_DINODE_FMT_LOCAL;
>  			ASSERT(*dirty > 0);
>  		} else  {
>  			do_warn(_(", would clear attr fork\n"));
> @@ -2135,7 +2134,6 @@ process_inode_attr_fork(
>  			/* clear attributes if not done already */
>  			if (!no_modify)  {
>  				*dirty += clear_dinode_attr(mp, dino, lino);
> -				dino->di_aformat = XFS_DINODE_FMT_LOCAL;
>  			} else  {
>  				do_warn(_("would clear attr fork\n"));
>  			}
> 
