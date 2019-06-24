Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B077C50C30
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 15:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbfFXNnS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 09:43:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38426 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728933AbfFXNnS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 09:43:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=r2fnnt0OaWJyJE6CNKgQySCAN9gmNppWBTC3aG8NuMo=; b=ltwFBM3x5hfT2o5/CDXYdqsSh
        im842rozNWRzpSMGJ4qLcL+1yzqvq8luaRy7zje+C/8LI9LtIOfhAO+uVYAWjhyU2UqwUqZhchH8p
        hGi/C8qWkiWbUXx1GDZIpjI8mIK0v+qo8j+arsWCjVKLNCUPFIbQ/J9ENhOItLrSfNo5YGHERHXmR
        GGD3L6PCUFlmfMtS15OAU8zS6GVmo8f0iUpssa0ndFgPyxp+EbguBp1Sa3p7Du/5nt5s8okOSkh2J
        ltfcb5HXl2zj4708ZbGwKP7mhwiu94Z4HM035+ryQTWUsRFRGkYQw+f6GBbfDG8r7dOsS2CF/Xm/D
        +yWFqEgIg==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfPFd-00077V-Hn; Mon, 24 Jun 2019 13:43:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: xfs cgroup writeback support
Date:   Mon, 24 Jun 2019 15:43:13 +0200
Message-Id: <20190624134315.21307-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this small series adds cgroup writeback support to XFS.  Unlike
the previous iteration of the support a few years ago it also
ensures that that trailing bios in an ioend inherit the right
cgroup.  It has been tested with the shared/011 xfstests test
that was written to test this functionality in all file systems,
and manually by Stefan Priebe.

This work was funded by Profihost AG.

Note that the first patch was also in my series to move the xfs
writepage code to iomap.c and the second one will conflict with
it.  We'll need to sort out which series to merge first, but given
how simple this one I would suggest to go for this one.
