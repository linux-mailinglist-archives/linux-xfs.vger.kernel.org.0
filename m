Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01D8FEF2DF
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2019 02:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387426AbfKEBgB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 Nov 2019 20:36:01 -0500
Received: from verein.lst.de ([213.95.11.211]:42467 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387416AbfKEBgA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Nov 2019 20:36:00 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id D47DF68BE1; Tue,  5 Nov 2019 02:35:58 +0100 (CET)
Date:   Tue, 5 Nov 2019 02:35:58 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/34] xfs: refactor btree node scrubbing
Message-ID: <20191105013558.GA32531@lst.de>
References: <20191101220719.29100-1-hch@lst.de> <20191101220719.29100-3-hch@lst.de> <20191104183617.GC4153244@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104183617.GC4153244@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 04, 2019 at 10:36:18AM -0800, Darrick J. Wong wrote:
> Seeing as this function returns a pointer to struct xfs_attr_leaf_entry,
> why not clean this up to:
> 
> ent = xfs_attr3_leaf_entryp(...)[blk->index]; ?

Well, it should really be xfs_attr3_leaf_entryp + blk->index.  But
otherwise agreed and fixed up for the next version.
