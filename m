Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 313171E88B
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 08:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfEOGup (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 02:50:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55722 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfEOGup (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 02:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=kXR791p50Ehjy41p49BoLye58
        WVnP8nhjpWysN2lpAWo/Uph+EXD5QJpIKop0lObEI6Z+0drMWHkh7YzDYiy5sHNadmwbI7N/WN7gh
        5pofimvPl3AQS1oKJT7Ey9nRNyB2jdpnrGD0iGGWHNVmJDfokosHClaa6m4b2wGugS370O4mIw3HI
        nUgiK/J4CPM2OR+vyogCwK4K5L59hlA8dIWnTp9UGQzhduMCTh6bza4Y8uFDV8m4+powMFem9/8WK
        u5DLa5PwSryzqmFOMF8cGefdwdtVf/LuW2b2nHJvxNB3HqkXDNtREwNh5Iw6BmuF4bQuJeyRtzq8N
        nY9ezldDQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQnkS-0000Of-Nd; Wed, 15 May 2019 06:50:44 +0000
Date:   Tue, 14 May 2019 23:50:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] libxfs: remove i_transp
Message-ID: <20190515065044.GA29211@infradead.org>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-2-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557519510-10602-2-git-send-email-sandeen@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
