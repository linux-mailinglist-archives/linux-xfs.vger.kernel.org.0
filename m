Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1557C1C65
	for <lists+linux-xfs@lfdr.de>; Mon, 30 Sep 2019 09:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbfI3Hzi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 30 Sep 2019 03:55:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42290 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729357AbfI3Hzi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 03:55:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=u+cmPUG16HW8YWL/e+WqCEAqa
        SnHGiEBiMwMI2MQwL4coQindEwCRa97NLpt/ycxjVZl09lQa7GFr0iDWG0HxB+jbh+GCPF3a9lspt
        pEBiNo7SzNap4sv3X4mgsmZ7VgoG/lqj9Nw0rIwGS64Re/nJg8VFKI2a1g+/tth3b23jc+Fmc2K8e
        J1u+daknMwVrqaTPXMJ/SjN6+qt2NVH3LDZBs5bmxwYDm/Ffp/PntMK2iOqi6inB5enUpFg/y1DP+
        V17MieZ4kt7Lnx4tAF95J3mRi2rXhMKu1sxCNOwxHVLt3dHco//W9AY7o8aWpyXL2W6TFD3u7pJks
        4CXYhoHCQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iEqWv-0003v3-9c; Mon, 30 Sep 2019 07:55:37 +0000
Date:   Mon, 30 Sep 2019 00:55:37 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: btheight should check geometry more carefully
Message-ID: <20190930075537.GJ27886@infradead.org>
References: <156944764785.303060.15428657522073378525.stgit@magnolia>
 <156944765385.303060.16945955453073433913.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156944765385.303060.16945955453073433913.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
