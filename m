Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F37781F9A
	for <lists+linux-xfs@lfdr.de>; Sun, 20 Aug 2023 21:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbjHTTmm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 20 Aug 2023 15:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbjHTTmj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Aug 2023 15:42:39 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 20 Aug 2023 12:37:39 PDT
Received: from smtp-outbound3.duck.com (smtp-outbound3.duck.com [20.67.221.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB4FF1
        for <linux-xfs@vger.kernel.org>; Sun, 20 Aug 2023 12:37:39 -0700 (PDT)
MIME-Version: 1.0
Subject: Moving existing internal journal log to an external device (success?)
Content-Type: text/plain;
        charset=US-ASCII;
        format=flowed
Content-Transfer-Encoding: 7bit
To:     linux-xfs@vger.kernel.org
Received: by smtp-inbound1.duck.com; Sun, 20 Aug 2023 15:37:38 -0400
Message-ID: <E4E991B0-4CAA-4E7A-9AC8-531346EDAEC4.1@smtp-inbound1.duck.com>
Date:   Sun, 20 Aug 2023 15:37:38 -0400
From:   fk1xdcio@duck.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=duck.com; h=From:
 Date: Message-ID: To: Content-Transfer-Encoding: Content-Type: Subject:
 MIME-Version; q=dns/txt; s=postal-KpyQVw; t=1692560258;
 bh=DRW8qpBLTThfPAANlmvowoyDrRh4nXMSMaBJHEuqdtk=;
 b=MrHD6f2YAgd7v32DCp98ygaXzGVfEKmou2qhmDO57CGL48dQfzUERHJp4P5pXRrtf+o/XypYB
 9Qewwb1qIfQCFPwOQnMIeNKOsJdI/PfY7f5VkcVKurp92V2+D4Max9MMHDdkRAnjQ+0Zf+sQfP/
 /IzOHc3KqVbnRXYa/LcZVRA=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Does this look like a sane method for moving an existing internal log to 
an external device?

3 drives:
    /dev/nvme0n1p1  2GB  Journal mirror 0
    /dev/nvme1n1p1  2GB  Journal mirror 1
    /dev/sda1       16TB XFS

# mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/nvme0n1p1 
/dev/nvme1n1p2
# mkfs.xfs /dev/sda1
# xfs_logprint -C journal.bin /dev/sda1
# cat journal.bin > /dev/md0
# xfs_db -x /dev/sda1

xfs_db> sb
xfs_db> write -d logstart 0
xfs_db> quit

# mount -o logdev=/dev/md0 /dev/sda1 /mnt

-------------------------

It seems to "work" and I tested with a whole bunch of data. I was also 
able to move the log back to internal without issue (set logstart back 
to what it was originally). I don't know enough about how the filesystem 
layout works to know if this will eventually break.

*IF* this works, why can't xfs_growfs do it?

Thanks!
