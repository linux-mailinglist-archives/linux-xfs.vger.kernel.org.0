Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE7119288A
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Mar 2020 13:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgCYMhr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Mar 2020 08:37:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47402 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbgCYMhr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 08:37:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=n3U/kV/DpZgkZ7UH8RG/nWXkNtXyHMNX/sn4NxxQjOI=; b=R0EwlVhvkU7SAYzyuLxR6yoyIp
        LSxmqXX8qhaThqugHpAqfrMsn5tVD4hdbNhqSO4fLfMN50ySQKAtXFTc1GnvCpICGK+iMH+9RWfEn
        J54zT4+/EygJkQEXueOcIKe8kdBdkFIrN46BtH1JyRdrjtpgZJOX9RUHTSILCWAXD7KBmOiHaldwB
        JXKsIABKah2IrdLW4pbK5bqItNvWtvX7NOpHmSvNAgt2j/8llEThlQIPg3TUpK2oPXTsnmJDUEEcc
        4KTtSeXEdjZu3WtAh4cznZM5FnXa5SlnnRSL1vpC+HT0uUvKnoGqsk5ftnrxZ7eCPISLTJTIMMjHC
        /+peGBAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jH5I0-0001qF-Fx; Wed, 25 Mar 2020 12:37:44 +0000
Date:   Wed, 25 Mar 2020 05:37:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Cc:     guaneryu@gmail.com, darrick.wong@oracle.com,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs/191: update mkfs.xfs input results
Message-ID: <20200325123744.GA6574@infradead.org>
References: <20190616143956.GC15846@desktop>
 <1560929963-2372-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560929963-2372-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 19, 2019 at 03:39:23PM +0800, Yang Xu wrote:
> Currently, on 5.2.0-rc4+ kernel, when I run xfs/191 with upstream
> xfsprogs, I get the following errors because mkfs.xfs binary has
> changed a lot.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

although this will need a rebase on top of:

xfs/191-input-validation:Fix issue that the test takes too long

which includes a hunk that is also present in this patch.
