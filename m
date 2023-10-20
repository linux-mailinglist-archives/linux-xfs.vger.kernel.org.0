Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FFB7D0838
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Oct 2023 08:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346971AbjJTGUa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 20 Oct 2023 02:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346657AbjJTGU3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2023 02:20:29 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88438D46
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 23:20:27 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 45A8667373; Fri, 20 Oct 2023 08:20:24 +0200 (CEST)
Date:   Fri, 20 Oct 2023 08:20:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com
Subject: Re: [PATCH 1/4] xfs: create a helper to handle logging parts of rt
 bitmap/summary blocks
Message-ID: <20231020062023.GA13551@lst.de>
References: <169773211338.225711.17480890063747608115.stgit@frogsfrogsfrogs> <169773211358.225711.13859802342332594222.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169773211358.225711.13859802342332594222.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 19, 2023 at 09:27:48AM -0700, Darrick J. Wong wrote:
> +	size_t			first, last;
> +
> +	first = (void *)xfs_rsumblock_infoptr(bp, infoword) - bp->b_addr;
> +	last = first + sizeof(xfs_suminfo_t) - 1;

> +	size_t			first, last;
> +
> +	first = (void *)xfs_rbmblock_wordptr(bp, from) - bp->b_addr;
> +	last = ((void *)xfs_rbmblock_wordptr(bp, next) - 1) - bp->b_addr;
> +
> +	xfs_trans_log_buf(tp, bp, first, last);

Going to pointers and back looks a bit confusing and rather inefficient
to me.  But given how late we are in the cycle I don't want to derail
your series, so let's keep this as-is for now, and I'll add a TODO
list item to my ever growing list to eventually lean this up.

