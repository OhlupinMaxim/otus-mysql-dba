insert into
    `Staff` (
        `username`,
        `password`,
        `staff_full_name`,
        `is_master_staff`,
        `staff_person_data`
    )
VALUES
    ('test', 'test', 'test', False, '{"inn": 12345}');


select staff_person_data from Staff;

update
    Staff
set
    staff_person_data = JSON_MERGE_PATCH(
        staff_person_data,
        '{"passport_serial": "123456", "passport_number": "123456"}'
    )
where
    username = 'test';

select staff_person_data from Staff;