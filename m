Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FFE330A23
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Mar 2021 10:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhCHJRa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Mar 2021 04:17:30 -0500
Received: from verein.lst.de ([213.95.11.211]:54791 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhCHJRB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 04:17:01 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3CD6068B05; Mon,  8 Mar 2021 10:16:59 +0100 (CET)
Date:   Mon, 8 Mar 2021 10:16:58 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH v2.1 3/4] xfs: force log and push AIL to clear pinned
 inodes when aborting mount
Message-ID: <20210308091658.GA3353@lst.de>
References: <161514874040.698643.2749449122589431232.stgit@magnolia> <161514875722.698643.971171271199400538.stgit@magnolia> <20210308044837.GN3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308044837.GN3419940@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
