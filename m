Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D8B7C7CA0
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Oct 2023 06:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjJMEYs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 13 Oct 2023 00:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjJMEYk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2023 00:24:40 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26556114
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 21:24:38 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id E966567373; Fri, 13 Oct 2023 06:24:34 +0200 (CEST)
Date:   Fri, 13 Oct 2023 06:24:34 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@osandov.com
Subject: Re: [PATCHSET RFC v1.0 0/7] xfs: clean up realtime type usage
Message-ID: <20231013042434.GB5562@lst.de>
References: <20231011175711.GM21298@frogsfrogsfrogs> <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs> <20231012050527.GJ1637@lst.de> <20231012223000.GR21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012223000.GR21298@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 03:30:00PM -0700, Darrick J. Wong wrote:
> The primary advantage that I can think of is code readability -- all the
> xfs_*rtb_ functions take xfs_rtblock_t types, and you can follow them
> all the way through the rt allocator/rmap/refcount code.  xfs_rtblock_t
> is a linear quantity even with rtgroups turned on.
> 
> The gross part is that one still has to know that br_startblock can be
> either xfs_fsblock_t or xfs_rtblock_t depending on inode and whichfork.

Yeah.

> That said, I don't think gcc actually warns about silent casts from
> xfs_fsblock_t to xfs_rtblock_t.


typedefs in C are syntactix shugar.  You will never get a warning about
mixing typedefs for the same underlying type (and often also not for
mixing with other integer types).  Having an annotation for a strong
typedef that can only do arithmetic on itself without casts or special
annotations would be really handy, though.
