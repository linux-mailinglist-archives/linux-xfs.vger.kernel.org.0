Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB4371613B0
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 14:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgBQNiu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 08:38:50 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48246 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgBQNit (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:38:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EtoO3gEzE1+AJ4EZG2G1EGHzPjAfTg9G3+B4tfVBw3s=; b=sfxzG9WiZQcOVxzJPXM6VYW/Yh
        Xq3TeLol4DwIxoUZ8eTAf6Q8SuCAJvnCRwqjoFHKumOAhlq4U0MCOVDhPVsMZ61N/1bsCcu+u7YUk
        dRWsuugmiY+W62JJZov3ZrAX72KcHPFUBAI3ncUcvhUyLvIaNseQQUHthMM7VxUUlR3KH8Tz+Rt35
        C+Y/D5jxYSkM8NIdlN5R88x8qno2H3xMk02XPH6adHgrAIbp8xbQPB7oE9HqApB50pS3qwpcjDQeo
        Gx8hukY6KPdmlXRWvYb8irHzZTbS0OX5IbPunRhPKbcyqQC2HAALFXraylCNQp+QQohIbLpD/gJ3M
        a5DBVIOQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gbp-0002da-Mn; Mon, 17 Feb 2020 13:38:49 +0000
Date:   Mon, 17 Feb 2020 05:38:49 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/4] xfs: pass xfs_dquot to xfs_qm_adjust_dqtimers
Message-ID: <20200217133849.GH31012@infradead.org>
References: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
 <f4fcefdf-3560-1b1d-fb67-cd289967b6e3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4fcefdf-3560-1b1d-fb67-cd289967b6e3@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 08, 2020 at 03:11:38PM -0600, Eric Sandeen wrote:
> Pass xfs_dquot rather than xfs_disk_dquot to xfs_qm_adjust_dqtimers;
> this makes it symmetric with xfs_qm_adjust_dqlimits and will help
> the next patch.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
