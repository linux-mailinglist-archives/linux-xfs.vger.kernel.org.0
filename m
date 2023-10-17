Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BE67CC842
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Oct 2023 18:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbjJQQAv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Oct 2023 12:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbjJQQAu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 12:00:50 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31AA9E
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 09:00:48 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6CF6568C4E; Tue, 17 Oct 2023 18:00:43 +0200 (CEST)
Date:   Tue, 17 Oct 2023 18:00:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/4] xfs: hoist freeing of rt data fork extent mappings
Message-ID: <20231017160042.GA20004@lst.de>
References: <169755740893.3165385.15959700242470322359.stgit@frogsfrogsfrogs> <169755740928.3165385.11991202448392574091.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169755740928.3165385.11991202448392574091.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 17, 2023 at 08:47:19AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, xfs_bmap_del_extent_real contains a bunch of code to convert
> the physical extent of a data fork mapping for a realtime file into rt
> extents and pass that to the rt extent freeing function.  Since the
> details of this aren't needed when CONFIG_XFS_REALTIME=n, move it to
> xfs_rtbitmap.c to reduce code size when realtime isn't enabled.
> 
> This will (one day) enable realtime EFIs to reuse the same
> unit-converting call with less code duplication.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
