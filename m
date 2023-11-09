Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6FE7E62E6
	for <lists+linux-xfs@lfdr.de>; Thu,  9 Nov 2023 05:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbjKIEop (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 Nov 2023 23:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjKIEop (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 23:44:45 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB002584
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 20:44:42 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A4D6767373; Thu,  9 Nov 2023 05:44:39 +0100 (CET)
Date:   Thu, 9 Nov 2023 05:44:39 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] repair: fix process_rt_rec_dups
Message-ID: <20231109044439.GA28458@lst.de>
References: <20231108175320.500847-1-hch@lst.de> <20231108180827.GW1205143@frogsfrogsfrogs> <20231108182101.GA17121@lst.de> <20231108192048.GX1205143@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231108192048.GX1205143@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2023 at 11:20:48AM -0800, Darrick J. Wong wrote:
> Correct.  The scan_bmapbt query is in units of rtblocks.  For
> rextsize==1 there's no error here; for rextsize > 2, the
> search_rt_dup_extent queries probe well past the end of the rt_ext_tree
> structure, so they never find the duplicate extents.
> 
> This /does/ explain why the one time I tried crosslinking rt extents I
> was surprised that xfs_repair didn't seem to detect them consistently.
> 
> Hmm, let me go clean all that up in to a TOTALLY UNTESTED patch.

This does looks sensible, but I suspect it makes more sense to do this
after merging the series to introduce xfs_rtxnum_t and friends in the
RT code.  I'll cook up a patch to just fix scan_bmapbt for now.

