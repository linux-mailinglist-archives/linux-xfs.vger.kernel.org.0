Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11607C7C8D
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Oct 2023 06:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjJMEWw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 13 Oct 2023 00:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjJMEWv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2023 00:22:51 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAF0BE
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 21:22:48 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id AAC4667373; Fri, 13 Oct 2023 06:22:45 +0200 (CEST)
Date:   Fri, 13 Oct 2023 06:22:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@osandov.com
Subject: Re: [PATCH 1/7] xfs: make sure maxlen is still congruent with prod
 when rounding down
Message-ID: <20231013042245.GA5562@lst.de>
References: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs> <169704720745.1773388.12417746971476890450.stgit@frogsfrogsfrogs> <20231012045954.GD1637@lst.de> <20231012173146.GD214073@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012173146.GD214073@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 10:31:46AM -0700, Darrick J. Wong wrote:
> /*
>  * Make sure we don't run off the end of the rt volume.  Be careful that
>  * adjusting maxlen downwards doesn't cause us to fail the alignment checks.
>  */
> static inline xfs_extlen_t
> xfs_rtallocate_clamp_len(
> 	struct xfs_mount	*mp,
> 	xfs_rtblock_t		startrtx,
> 	xfs_extlen_t		rtxlen,
> 	xfs_extlen_t		prod)
> {
> 	xfs_extlen_t		ret;
> 
> 	ret = min(mp->m_sb.sb_rextents, startrtx + rtxlen) - startrtx;
> 	return rounddown(ret, prod);
> }
> 
> 	minlen = xfs_rtallocate_clamp_len(mp, i, maxlen, prod);
> 
> and
> 
> 	minlen = xfs_rtalloc_clamp_len(mp, bno, maxlen, prod);

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
