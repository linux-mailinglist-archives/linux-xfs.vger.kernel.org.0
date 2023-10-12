Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEF37C649B
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Oct 2023 07:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbjJLFZS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Oct 2023 01:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbjJLFZS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 01:25:18 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D480B7
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 22:25:17 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 95C586732D; Thu, 12 Oct 2023 07:25:12 +0200 (CEST)
Date:   Thu, 12 Oct 2023 07:25:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 7/7] xfs: use shifting and masking when converting rt
 extents, if possible
Message-ID: <20231012052511.GF2184@lst.de>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs> <169704721284.1773611.1915589661676489.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <169704721284.1773611.1915589661676489.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 11:06:14AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Avoid the costs of integer division (32-bit and 64-bit) if the realtime
> extent size is a power of two.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Do you have any data on how common non-power of two rtext sizes are?
Might it be worth to add unlikely annotations?

> @@ -11,6 +11,9 @@ xfs_rtx_to_rtb(
>  	struct xfs_mount	*mp,
>  	xfs_rtxnum_t		rtx)
>  {
> +	if (mp->m_rtxblklog >= 0)
> +		return rtx << mp->m_rtxblklog;
> +
>  	return rtx * mp->m_sb.sb_rextsize;

i.e.

	if (unlikely(mp->m_rtxblklog == ‐1))
	  	return rtx * mp->m_sb.sb_rextsize;
	return rtx << mp->m_rtxblklog;

