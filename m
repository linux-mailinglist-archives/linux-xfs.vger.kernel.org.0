Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2652D3C89
	for <lists+linux-xfs@lfdr.de>; Wed,  9 Dec 2020 08:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgLIHyr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 9 Dec 2020 02:54:47 -0500
Received: from verein.lst.de ([213.95.11.211]:49040 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgLIHyr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Dec 2020 02:54:47 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id E12BD6736F; Wed,  9 Dec 2020 08:54:05 +0100 (CET)
Date:   Wed, 9 Dec 2020 08:54:05 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v4 5/6] xfs: spilt xfs_dialloc() into 2 functions
Message-ID: <20201209075405.GB10645@lst.de>
References: <20201208122003.3158922-1-hsiangkao@redhat.com> <20201208122003.3158922-6-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208122003.3158922-6-hsiangkao@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
