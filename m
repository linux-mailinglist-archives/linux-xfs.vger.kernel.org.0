Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21ED7C6444
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Oct 2023 07:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbjJLFAs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Oct 2023 01:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjJLFAr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 01:00:47 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116A0B7
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 22:00:46 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 829F768AFE; Thu, 12 Oct 2023 07:00:43 +0200 (CEST)
Date:   Thu, 12 Oct 2023 07:00:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 3/7] xfs: convert xfs_extlen_t to xfs_rtxlen_t in the
 rt allocator
Message-ID: <20231012050042.GE1637@lst.de>
References: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs> <169704720774.1773388.15846305158616206845.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704720774.1773388.15846305158616206845.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 11:03:21AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In most of the filesystem, we use xfs_extlen_t to store the length of a
> file (or AG) space mapping in units of fs blocks.  Unfortunately, the
> realtime allocator also uses it to store the length of a rt space
> mapping in units of rt extents.  This is confusing, since one rt extent
> can consist of many fs blocks.
> 
> Separate the two by introducing a new type (xfs_rtxlen_t) to store the
> length of a space mapping (in units of realtime extents) that would be
> found in a file.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
