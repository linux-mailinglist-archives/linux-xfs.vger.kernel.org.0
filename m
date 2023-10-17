Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB3E7CB9B1
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Oct 2023 06:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjJQEUT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Oct 2023 00:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbjJQEF5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 00:05:57 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FF88E
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 21:05:55 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A5A6467373; Tue, 17 Oct 2023 06:05:52 +0200 (CEST)
Date:   Tue, 17 Oct 2023 06:05:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@osandov.com
Subject: Re: [PATCHSET RFC v1.0 0/7] xfs: clean up realtime type usage
Message-ID: <20231017040552.GA6025@lst.de>
References: <20231011175711.GM21298@frogsfrogsfrogs> <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs> <20231012050527.GJ1637@lst.de> <20231012223000.GR21298@frogsfrogsfrogs> <20231013042434.GB5562@lst.de> <20231017004831.GD11402@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231017004831.GD11402@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2023 at 05:48:31PM -0700, Darrick J. Wong wrote:
> We can do it crappily in C with __bitwise and letting the static checker
> bots go wild.  Some day when someone rewrites the entire codebase in
> Rust (HA!) then we'll be able to do:
> 
> struct xfs_fsblock_t(u64);
> struct xfs_agblock_t(u32);
> 
> and (to the extent that I understand Rust) the Rust compiler will
> complain about stuffing xfs_agblock_t into an xfs_fsblock_t without a
> proper conversion.

You can do the struct in C already.  Linux actually does it for PTE
types optionally.  It's just a real pain in the butt if your regularly
do arithmetics on it, which we do for the various block/size/offset
types.

> 
> --D
---end quoted text---
