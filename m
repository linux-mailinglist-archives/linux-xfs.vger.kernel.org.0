Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF763C5B51
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Jul 2021 13:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbhGLLOu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Jul 2021 07:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhGLLOu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jul 2021 07:14:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3C0C0613DD;
        Mon, 12 Jul 2021 04:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=wfNgLCoMaMRfiX6voCiSUv8fNinqdtRu7maX5BQRvw0=; b=oSt4lAz8eUjy0Mt4a1Yk34zuf0
        s0+xgtV9k4jH8ecnReJNjTfu2MwISTsFClNE/VgeumgJOEBzhBAd+umOr6ah3nv+y6vkaQP3Hy+/q
        xRybX1MZVNECDhI8zP2iJ8pgOVP+KAqmfGp601BTSmb7QvYAnQiLVJoq7v2kviHQVSIEd+owu82Di
        WY2HEmqAv6L8X9egQI3V87uVZzHdMKxrmAsaPGsFMmnQpNy0e8ACDiqnv3bCnDSDF/gE2sDgUAKtU
        9xxUxU7Yys0SitnPKgNFnS01DVXcSoZz6VcY3haIdWGmlbhOw1CV/f6vYqrBs0cTAzi3zL9+LMdMB
        AgHkHe6A==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2tql-00HXCh-KW; Mon, 12 Jul 2021 11:11:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: prepare for removing support to disable quota accounting
Date:   Mon, 12 Jul 2021 13:11:40 +0200
Message-Id: <20210712111146.82734-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series contains all the patches to make xfstests cope with a kernel
that does not support disabling quota accounting on a running XFS file
system.
