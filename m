Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F132EEEE9
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Jan 2021 09:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbhAHIzl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Jan 2021 03:55:41 -0500
Received: from verein.lst.de ([213.95.11.211]:43088 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbhAHIzk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Jan 2021 03:55:40 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id DB90168AFE; Fri,  8 Jan 2021 09:54:58 +0100 (CET)
Date:   Fri, 8 Jan 2021 09:54:58 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/13] gfs2: don't worry about I_DIRTY_TIME in
 gfs2_fsync()
Message-ID: <20210108085458.GB1438@lst.de>
References: <20210105005452.92521-1-ebiggers@kernel.org> <20210105005452.92521-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105005452.92521-3-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
